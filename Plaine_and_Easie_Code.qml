import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import MuseScore 3.0
import QtQuick.Dialogs 1.2
import Qt.labs.settings 1.0


// per navigazione directory
import Qt.labs.folderlistmodel 2.1
// per scrittura
import FileIO 3.0

MuseScore {
    menuPath: "Plugins.Plugin per la traduzione da MuseScore a Plaine & Easie Code"
	description: "MuseScore to Plaine & Easie Code conversion plug-in"
	pluginType: "dialog"

	Component.onCompleted: {
		// runs once before console.log is ready
		if (mscoreMajorVersion >= 4) {
			title = "Musescore to PAE";
		}
	}



    //#################################################
    //##################### GUI #######################
    //#################################################

    id: mainWindow
	width:  700
	height: 800

    // PARAMETRI DI DEFAULT
	property int grandezzaTitolo: 18
	property int grandezzaSottotitolo: 16
	property int larghezzaBottone: 80
	property int piccolaLarghezza: 150
	property int mediaLarghezza: 400
	property int grandeLarghezza: 645
	property int altezzaStandard: 30
	property int altezzaGrande: 45
    property int altezzaGiga: 200
	property int grandezzaFontStandard: 14
	property int grandezzaHeader: 24
	property int dimensioneRaggio: 10
	property string coloreTitolo: "#3399ff"
	property string coloreSottotitolo: "#003d99"
	property string coloreBottone: "white"
	property string coloreHeader: "lightgray"
	property string coloreExportDirectory: "#ff0000"
	property string coloreExportDirectoryInLine: "#75a3a3"


    //Header
    Rectangle {
		id: header
		width: mainWindow.width
		height: 80
		color: coloreHeader
		anchors.top: mainWindow.top

		Label {
			text: "MuseScore to Plaine & Easie Code"
			font.pixelSize: grandezzaHeader
			font.weight: Font.Bold

			anchors.centerIn: parent
		}
	}

    //Traduzione in PAE
    Label {
		id: subTitlePAE
		text: "\nPlaine & Easie Code Traduction\n"

		color: coloreTitolo
		font.pixelSize: grandezzaTitolo
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter
		width: mainWindow.width
		height: altezzaGrande

		anchors.top: header.bottom
		anchors.topMargin: 20
	}

    Label {
		id: labelSpacerPAE
		text: ""
		font.pixelSize: grandezzaFontStandard
		width: 25
		height: altezzaGiga
		horizontalAlignment: Text.AlignRight
		verticalAlignment: Text.AlignVCenter
		anchors.topMargin: 20
	}

	Label {
		id: labelPAE
		text: curScore.title + "_PAE"
		color: coloreSottotitolo
		font.pixelSize: grandezzaSottotitolo
		
		anchors.top: subTitlePAE.bottom;
		anchors.left: labelSpacerPAE.right
		anchors.leftMargin: 10
		width: mainWindow.width
		height: 20
		verticalAlignment: Text.AlignVCenter
	}

	Rectangle {
		id: rectPAE
		width: grandeLarghezza
		height: altezzaGiga
		border.color: "grey"

		anchors.top: labelPAE.bottom;
		anchors.left: labelSpacerPAE.right
		anchors.topMargin: 10

		ColumnLayout {
			anchors.fill: parent

			ScrollView {
				Layout.fillWidth: true
				Layout.fillHeight: true

				TextArea {
					id: myTextArea
					font.pixelSize: grandezzaFontStandard
					text: creaPAE()
					
					selectByKeyboard: true
					selectByMouse: true
					wrapMode: TextArea.WrapAtWordBoundaryOrAnywhere

					color: "black"
					//enabled: false
				}
			}
		}
	}
    
    //Impostazioni esportazione
    Label {
		id: globalTitle
		text: "\nExport Settings\n"

		color: coloreTitolo
		font.pixelSize: grandezzaTitolo
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter
		width: mainWindow.width
		height: altezzaGrande

		anchors.top: rectPAE.bottom
		anchors.topMargin: 20
	}

    Label {
		id: labelSpacerTitle
		text: ""
		font.pixelSize: grandezzaFontStandard
		width: piccolaLarghezza
		height: altezzaGrande
		horizontalAlignment: Text.AlignRight
		verticalAlignment: Text.AlignVCenter
	}

	Label {
		id: labelTitle
		text: "Name and Path"
		color: coloreSottotitolo
		font.pixelSize: grandezzaSottotitolo
		anchors.left: labelSpacerTitle.right
		anchors.top: globalTitle.bottom
		width: piccolaLarghezza
		height: altezzaGrande
		verticalAlignment: Text.AlignVCenter
	}

	//Nome file
	Label {
		id: labelTextFieldTitle
		text: "File name  "
		font.pixelSize: grandezzaFontStandard
		anchors.top: labelTitle.bottom;
		width: piccolaLarghezza
		height: altezzaStandard
		horizontalAlignment: Text.AlignRight
		verticalAlignment: Text.AlignVCenter
	}


	TextField {
		id: textFieldTitle
		font.pixelSize: grandezzaFontStandard
		placeholderText: "You need to set a name"

		text: curScore.title + "_PAE"
		anchors.top: labelTitle.bottom;
		anchors.left: labelTextFieldTitle.right;
		width: mediaLarghezza
		height: altezzaStandard
	}


	Button {
		id: buttonFileTitle
		text: "⌫ Clear"
		anchors.top: labelTitle.bottom;
		anchors.left: textFieldTitle.right;
		width: larghezzaBottone
		height: altezzaStandard
		anchors.leftMargin:5

		background: Rectangle {
			color: coloreBottone  
			radius: dimensioneRaggio
		}

		MouseArea {
			anchors.fill: parent
			onClicked: textFieldTitle.text = ""
		}
	}

    //Percorso file
	Label {
		id: labelPath
		text: "File path  "
		font.pixelSize: grandezzaFontStandard
		anchors.top: labelTextFieldTitle.bottom;
		width: piccolaLarghezza
		height: altezzaStandard
		horizontalAlignment: Text.AlignRight
		verticalAlignment: Text.AlignVCenter
	}

	TextField {
		id: exportDirectory
		anchors.top: labelTextFieldTitle.bottom
		anchors.left: labelPath.right
		anchors.topMargin:5
		placeholderText: "PATH NOT SELECTED YET"
		color: coloreExportDirectory
		width: mediaLarghezza
		height: altezzaStandard
		enabled: false
	}

	FileDialog {
		id: directorySelectDialog
		title: qsTranslate("MS::PathListDialog", "Choose a directory")

		selectFolder: true
		visible: false

		onAccepted: {
			exportDirectory.text = this.folder.toString().replace("file://", "").replace(/^\/(.:\/)(.*)$/, "$1$2");
			exportDirectory.color = coloreExportDirectoryInLine
		}
	}

	Button {
		id: selectDirectory
		width: larghezzaBottone
		height: altezzaStandard
		anchors.left: exportDirectory.right
		anchors.top: textFieldTitle.bottom
		anchors.leftMargin:5
		anchors.topMargin:5
		text: "📂"


		background: Rectangle {
			color: coloreBottone  
			radius: dimensioneRaggio  
		}

		onClicked: {
			directorySelectDialog.open();
		}

	}

    MessageDialog {
		id: endDialog
		visible: false
		title: qsTr("Conversion performed")
		text: "Score has been successfully created"

		// Compatibilità MuseScore 4
		onAccepted: {
			(typeof(quit) === 'undefined' ? Qt.quit : quit)()
		}

		function openEndDialog(message) {
			text = message
			open()
		}
	}

	MessageDialog {
		id: errorDialog
		visible: false
		title: qsTr("Error")
		text: "Error"

		onAccepted: {
			close()
		}

		function openErrorDialog(message) {
			text = message
			open()
		}
	}

    //Bottoni crea e chiudi
    Rectangle {
		id: bottoni
		width: mainWindow.width
		anchors.top: labelPath.bottom
		anchors.left: mainWindow.left
		anchors.topMargin: 30
		anchors.leftMargin: 220

		RowLayout {
			spacing: 130

			Button {
				id: buttonCreate
				text: "✓ Create"
				background: Rectangle {
					color: "#ccff99"
					radius: dimensioneRaggio
				}

				width: larghezzaBottone
				height: altezzaStandard

				onClicked: {
					// CREO IL FILE
					creaFileTxt()
				}
			}


			Button {
				id: buttonClose
				text: "✕ Close"
				background: Rectangle {
					color: "#ff6666"
					radius: dimensioneRaggio
				}

				width: larghezzaBottone
				height: altezzaStandard

				// Compatibilità MuseScore 4
				onClicked: {
					(typeof(quit) === 'undefined' ? Qt.quit : quit)()
				}
			}
		}
	}

    //Footer
	Rectangle {
		id: footer
		width: mainWindow.width
		height: mainWindow.height * 0.20
		color: coloreHeader
		anchors.bottom: mainWindow.bottom
		Label {
			text: "\nThis plugin was created as part of a three-year thesis in\n\"Informatica Musicale\"(University of Milan)\n\nFor any support it is advisable to contact the developer (Francesco Masaneo) at:\n francesco.masaneo\@studenti.unimi.it "
			anchors.centerIn: parent
		}
	}
	


    //#################################################
    //################ FILE CREATION ##################
    //#################################################

	FileIO {
		id: txtWriter
		onError: console.log(msg + "  Filename = " + txtWriter.source)
	}

	function creaFileTxt() {
		//Controllo nome file e directory
		if (!textFieldTitle.text) {
			errorDialog.openErrorDialog(qsTr("File name not specified"))
			return
		} else if (!exportDirectory.text) {
			errorDialog.openErrorDialog(qsTr("File folder not specified"))
			return
		}

		var TestoFile = "[MUSESCORE TO PAE PLUGIN] TITLE: " + curScore.title + "\n" + "\n";

		// chiamo Funzione che permette di creare la traduzione in PAE e restituisce
		// il testo tradotto
		TestoFile += creaPAE()


		var nomeFile =  exportDirectory.text + "/" + textFieldTitle.text + ".txt"
		console.log("Export to " + nomeFile)
		txtWriter.source = nomeFile
		console.log("Writing Txt...")

		// inserisco il testo
		txtWriter.write(TestoFile)
		console.log("writed")
		endDialog.open()
	}
	


    //#################################################
    //################### FUNZIONI ####################
    //#################################################

	function getOctave(note) {
		var octave = note.pitch / 12
		if (note.tpc == 0 || note.tpc == 7)
			octave++
		if (note.tpc == 26 || note.tpc == 33)
			octave--
		return Math.floor(octave)
	}


    //Usato per la chiave, restituisce il nome della nota in base al tcp della nota in input
	function getNomeNota(note) {
		var tpc = note.tpc1
		switch (tpc % 7) {
			case 0:
				return "C"
			case 2:
				return "D"
			case 4:
				return "E"
			case 6:
				return "F"
			case -1:
				return "F"
			case 1:
				return "G"
			case 3:
				return "A"
			case 5:
				return "B"
		}
		return "none"
	}


	//Restituisce la chiave in PAE da p
    function getChiave(pentagramma){
		var tutteLeNote = ["C", "D", "E", "F", "G", "A", "B"]
		var chiaveSOL = {};					//Chiave di SOL
		var ultimaNotaChiaveSOL = 6;

		var chiaveFA = {};					//Chiave di FA
		var ultimaNotaChiaveFA = 4;

		var chiaveFA3 = {};					//Baritono (%F-3)
		var ultimaNotaChiaveFA3 = 2;

		var chiaveDO1 = {};					//Soprano (%C-1)
		var ultimaNotaChiaveDO1 = 1;

		var chiaveDO2 = {};					//Mezzo-soprano (%C-2)
		var ultimaNotaChiaveDO2 = 3;

		var chiaveDO3 = {};					//Chiave di DO, contralto (%C-3)
		var ultimaNotaChiaveDO3 = 5;

		var chiaveDO4 = {};					//Tenore (%C-4)
		var ultimaNotaChiaveDO4 = 0;

		var posizione = -12.5
		
		// CREO ARRAY DELLE CHIAVI:
		for (var i = 0; i < 72; i += 1) {
			chiaveSOL[posizione] = tutteLeNote[6-ultimaNotaChiaveSOL]
			if (ultimaNotaChiaveSOL == 6) {
				ultimaNotaChiaveSOL = 0
			} else {
				ultimaNotaChiaveSOL += 1
			}

			chiaveFA[posizione] = tutteLeNote[6-ultimaNotaChiaveFA]
			if (ultimaNotaChiaveFA == 6) {
				ultimaNotaChiaveFA = 0
			} else {
				ultimaNotaChiaveFA += 1
			}

			chiaveFA3[posizione] = tutteLeNote[6-ultimaNotaChiaveFA3]
			if (ultimaNotaChiaveFA3 == 6) {
				ultimaNotaChiaveFA3 = 0
			} else {
				ultimaNotaChiaveFA3 += 1
			}

			chiaveDO1[posizione] = tutteLeNote[6-ultimaNotaChiaveDO1]
			if (ultimaNotaChiaveDO1 == 6) {
				ultimaNotaChiaveDO1 = 0
			} else {
				ultimaNotaChiaveDO1 += 1
			}

			chiaveDO2[posizione] = tutteLeNote[6-ultimaNotaChiaveDO2]
			if (ultimaNotaChiaveDO2 == 6) {
				ultimaNotaChiaveDO2 = 0
			} else {
				ultimaNotaChiaveDO2 += 1
			}

			chiaveDO3[posizione] = tutteLeNote[6-ultimaNotaChiaveDO3]
			if (ultimaNotaChiaveDO3 == 6) {
				ultimaNotaChiaveDO3 = 0
			} else {
				ultimaNotaChiaveDO3 += 1
			}

			chiaveDO4[posizione] = tutteLeNote[6-ultimaNotaChiaveDO4]
			if (ultimaNotaChiaveDO4 == 6) {
				ultimaNotaChiaveDO4 = 0
			} else {
				ultimaNotaChiaveDO4 += 1
			}

			posizione += 0.5
		}

		var myCursor = curScore.newCursor()
		myCursor.staffIdx = pentagramma
		myCursor.rewind(0)

		do {
			// QUANDO TROVO UN ACCORDO
            if (myCursor.element == null)
                continue
			if (myCursor.element.type == Element.CHORD) {
				// SE SI PUO' DEFINIRE UN PITCH
				if (curScore.parts[0].hasPitchedStaff) {
					var note = myCursor.element.notes[0]
					var position = Math.round(note.posY * 10) /10

					switch (getNomeNota(note)) {
						// 3 possibilità se rientra nell'array chiaveSOL: chiave di SOL, chiave di Sol 8va sotto o
						// chiave di Fa su linea 5  (subbasso)
						case chiaveSOL[position]:
							if (position <= 15.5 && position >= 12.5) {
								switch (getOctave(note)) {
									case 2:
										return "%G-2"
									case 1:
										return "%g-2"
									case 0:
										return "%F-5"
								}
							} else if (position <= 12 && position  >= 9) {
								switch (getOctave(note)) {
									case 3:
										return "%G-2"
									case 2:
										return "%g-2"
									case 1:
										return "%F-5"
								}

							} else if (position <= 8.5 && position  >= 5.5) {
								switch (getOctave(note)) {
									case 4:
										return "%G-2"
									case 3:
										return "%g-2"
									case 2:
										return "%F-5"
								}
							} else if (position <= 5 && position  >= 2) {
								switch (getOctave(note)) {
									case 5:
										return "%G-2"
									case 4:
										return "%g-2"
									case 3:
										return "%F-5"
								}
							} else if (position <= 1.5 && position  >= -1.5) {
								switch (getOctave(note)) {
									case 6:
										return "%G-2"
									case 5:
										return "%g-2"
									case 4:
										return "%F-5"
								}
							} else if (position <= -2 && position >= -5 ) {
								switch (getOctave(note)) {
									case 7:
										return "%G-2"
									case 6:
										return "%g-2"
									case 5:
										return "%F-5"
								}
							} else if (position <= -5.5 && position >= -8.5 ) {
								switch (getOctave(note)) {
									case 8:
										return "%G-2"
									case 7:
										return "%g-2"
									case 6 :
											return "%F-5"
								}
							} else if (position <= -9 && position >= -12 ) {
								switch (getOctave(note)) {
									case 8:
										return "%g-2"
									case 7:
										return "%F-5"
								}
							}
							return "None"

						// Due soluzioni: chiave di FA o violino francese
						case chiaveFA[position]:
							if (position <= 16 && position  >= 13) {
								switch (getOctave(note)) {
									case 3:
										return "%G-1"
									case 0:
										return "%F-4"
								}
							} else if (position <= 12.5 && position  >= 9.5) {
								switch (getOctave(note)) {
									case 4:
										return "%G-1"
									case 1:
										return "%F-4"
								}
							} else if (position <= 9 && position  >= 6) {
								switch (getOctave(note)) {
									case 5:
										return "%G-1"
									case 2:
										return "%F-4"
								}
							} else if (position <= 5.5 && position  >= 2.5) {
								switch (getOctave(note)) {
									case 6:
										return "%G-1"
									case 3:
										return "%F-4"
								}
							} else if (position <= 2 && position >= -1 ) {
								switch (getOctave(note)) {
									case 7:
										return "%G-1"
									case 4:
										return "%F-4"
								}
							} else if (position <= -1.5 && position >= -4.5 ) {
								switch (getOctave(note)) {
									case 8:
										return "%G-1"
									case 5:
										return "%F-4"
								}
							} else if (position <= -5 && position >= -8 ) {
								switch (getOctave(note)) {
									case 9:
										return "%G-1"
									case 6:
										return "%F-4"
								}
							} else if (position <= -8.5 && position >= -11.5 ) {
								switch (getOctave(note)) {
									case 10:
										return "%G-1"
									case 7:
										return "%F-4"
								}
							} else {
								return "%F-4"
							}
							return "None"

						case chiaveFA3[position]:
							// caso Chiave di Do su 3a linea / chiave di baritono
							// sono indistinguibili purtroppo: hanno stesse altezze
							return "%F-3"			//Baritono
						case chiaveDO1[position]:
							return "%C-1"			//Soprano
						case chiaveDO2[position]:
							return "%C-2"			//Mezzo-soprano
						case chiaveDO3[position]:
							return "%C-3"			//Contralto
						case chiaveDO4[position]:
							return "%C-4"			//Tenore
						default:
							return ""
					}
					return ""
				}
			}
		} while (myCursor.next())

		return "% Clef undefined"
	}

	//Restituisce l'armatura di chiave in PAE da curScore.keysig
	function getArmChiave(k) {
		switch (k) {
			case 1:
				return "$xF"
			case 2:
				return "$xFC"
			case 3:
				return "$xFCG"
			case 4:
				return "$xFCGD"
			case 5:
				return "$xFCGDA"
			case 6:
				return "$xFCGDAE"
			case 7:
				return "$xFCGDAEB"
			case -1:
				return "$bB"
			case -2:
				return "$bBE"
			case -3:
				return "$bBEA"
			case -4:
				return "$bBEAD"
			case -5:
				return "$bBEADG"
			case -6:
				return "$bBEADGC"
			case -7:
				return "$bBEADGCF"
			default:
				return ""
		}
		
	}

	//Restituisce l'indicazione metrica in PAE da p
	function getMetro(stato) {
		var metro = "@"
		var cursor = curScore.newCursor()
		var segment = curScore.firstSegment();

		do {
			var element = segment.elementAt(0)

			if (segment.segmentType == 0x10) {
				if (element.timesigType == 1) {
					metro += "c "
					stato.durataC = 1
				} else if (element.timesigType == 2) {
					metro += "c/ "
					stato.durataC = 0.5
				} else if (element.timesigType == 3) {
					metro += "2 "
					stato.durataC = 1
				} else if (element.timesigType == 4) {
					metro += "3 "
					stato.durataC = 1.125
				} else {
					if (element.numeratorString) {
						metro += element.numeratorString + "/";
						metro += element.denominatorString + " ";
						stato.durataC = element.numeratorString/element.denominatorString ;
					} else {
						metro += element.timesig.numerator + "/";
						metro += element.timesig.denominator + " ";
						stato.durataC = element.timesig.numerator / element.timesig.denominator;
					}
				}
				return metro
			}
			segment = segment.next

			if (!segment) {
				break
			}
		} while (segment)
		// non ho trovato un metro
		return "@ Metro undefined"
	}

	//Restituisce ottava, altezza e alterazione nota in PAE
	function nomeNota(nota, ott) {
		var ottava = getOctave(nota);
		var tpc = nota.tpc1 + 1;
		var alterazioni = Math.floor(tpc / 7);		//0 + nota.accidentalType
		var altezza = tpc % 7;

		var nome = "";
		if (ott) {
			//Aggiunge ottava solamente se è diversa da quella inserita precedentemente
			nome += [",,,,,", ",,,,", ",,,", ",,", ",", "'", "''", "'''", "''''", "'''''", "''''''"][ottava];
		}
		nome += ["bb", "b", "", "x", "xx"][alterazioni];			//["", "b", "n", "x", "xx", "bb"][alterazioni]
		nome += ["F", "C", "G", "D", "A", "E", "B"][altezza];
		//["₋₁", "₀", "₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉"][ottava]
		//["F", "C", "G", "D", "A", "E", "B"][altezza]
		//["𝄫", "♭", "", "♯", "𝄪"][alterazioni]
		
		return nome;
	}

	//Restituisce la durata in PAE da duration.numerator e duration.denominator
	function getDurata(dur) {
		switch (dur) {
			case ((16/4) + (8/4) + (4/4)):
				return "0.."		// longa ..
			case ((16/4) + (8/4)):
				return "0."			// longa .
			case (16/4):
				return "0"			// longa
			case ((8/4) + (4/4) + (2/4)):
				return "9.."		// breve ..
			case ((8/4) + (4/4)):
				return "9."			// breve .
			case (8/4):
				return "9"			// breve
			case ((4/4) + (2/4) + (1/4)):
				return "1.."		// semibreve ..
			case ((4/4) + (2/4)):
				return "1."			// semibreve .
			case (4/4):
				return "1"			// semibreve
			case ((2/4) + (1/4) + (1/8)):
				return "2.."		// metà ..
			case ((2/4) + (1/4)):
				return "2."			// metà .
			case (2/4):
				return "2"			// metà 
			case ((1/4) + (1/8) + (1/16)):
				return "4.."		// quarto ..
			case ((1/4) + (1/8)):
				return "4."			// quarto .
			case (1/4):
				return "4"			// quarto 
			case ((1/8) + (1/16) + (1/32)):
				return "8.."		// ottavo ..
			case ((1/8) + (1/16)):
				return "8."			// ottavo .
			case (1/8):
				return "8"			// ottavo
			case ((1/16) + (1/32) + (1/64)):
				return "6.."		// sedicesimo ..
			case ((1/16) + (1/32)):
				return "6."			// sedicesimo .
			case (1/16):
				return "6"			// sedicesimo
			case ((1/32) + (1/64) + (1/128)):
				return "3.."		// trentadueesimo ..
			case ((1/32) + (1/64)):
				return "3."			// trentadueesimo .
			case (1/32):
				return "3"			// trentadueesimo
			case ((1/64) + (1/128) + (1/256)):
				return "5.."		// sessantaquattresimo ..
			case ((1/64)+(1/128)):
				return "5."			// sessantaquattresimo .
			case (1/64):
				return "5"			// sessantaquattresimo
			case ((1/128)+ (1/256) + (1/512)):
				return "7.."		// centoventottesimo ..
			case ((1/128)+ (1/256)):
				return "7."			// centoventottesimo .
			case (1/128):
				return "7"			// centoventottesimo
			default:
				return "ND"
		}
	}

	function accordo(notes, stato) {
		var accordo = "";
		var noteInAcc = notes.length;

		for (var i = 0; i < noteInAcc; i++) {
			if (i > 0) {
				accordo += "^"
			}
			var nota = notes[i]
			var ottava = getOctave(nota);
			if (stato.ott == "") {
				//Prima volta che inserisco ottava
				stato.ott = [",,,,,", ",,,,", ",,,", ",,", ",", "'", "''", "'''", "''''", "'''''", "''''''"][ottava];
				accordo += nomeNota(nota, true);
			} else {
				var ott1 = [",,,,,", ",,,,", ",,,", ",,", ",", "'", "''", "'''", "''''", "'''''", "''''''"][ottava];
				if (stato.ott == ott1) {
					//L'ottava rimane invariata
					accordo += nomeNota(nota, false);
				} else if (stato.ott !== ott1) {
					//Ottava attuale è diversa da quella precedente
					stato.ott = ott1
					accordo += nomeNota(nota, true);
				}
			}
		}

		return accordo
	}

    function tipoBarra (bar) {
		if (bar == 1) {
			return " / "		// BARRA NORMALE / SINGOLA
		} else if (bar == 0x20) {		//32 in esadecimale
			return " // "		// FINE BARRA
		} else if (bar == 2) {
			return " // "		// BARRA DOPPIA (in PAE si indica allo stesso modo di fine barra)
		} else if (bar == 4) {
			return " //: "		// INIZIO_RIPETI
		} else if (bar == 8) {
			return " :// "		// FINE_RIPETI
		} else {
			return ""
		}
	}

    function rilStanghette() {
		var stanghette = [];
		var seg = curScore.firstSegment();

		//Ciclo per completare array stanghette[]
		do {
			var isBarLine = !!(Segment.BarLineType & seg.segmentType);	//Controlla la presenza delle stanghette
			if (isBarLine && seg.segmentType != Segment.BeginBarLine) {
				//Se è presente la stanghetta
				var stanghettaTrovata = tipoBarra(seg.elementAt(0).barlineType)

				if (seg.segmentType == Segment.StartRepeatBarLine) {
					//Se ci troviamo a inizio spartito rimuove la barra dall'array stanghette[]
					stanghette.pop()
				}
				stanghette.push(stanghettaTrovata)		//Aggiunge la nuova stanghetta all'array stanghette[]
			}
			seg = seg.next;
		} while (seg.next)
		
		var lastbar = 0
		var numBattute = 0
		var cursor1 = curScore.newCursor()
		cursor1.rewind(0)

		//Ciclo per inserire nell'array stanghette[] l'ultima barra dello spartito
		do {
			numBattute+=1
			var segment = cursor1.measure.lastSegment;
			var bar = segment.elementAt(0);
			var lastbar = bar.barlineType
		}
		while (cursor1.nextMeasure())

		stanghette.push(tipoBarra(lastbar))		//Array completo
		
		//Variabile booleana che indica se lo spartito incomincia con le stanghette
		var iniziaConStanghetta = !(numBattute == stanghette.length)

		var res = [iniziaConStanghetta, stanghette]
		return  res
	}
		


    //#################################################
    //################### CREA PAE ####################
    //#################################################

    function creaPAE() {
        var stanghette = rilStanghette();
        var testo = "";

        var cursor = curScore.newCursor();
        cursor.track = 0
        cursor.rewind(0)

		var stato = {
			durata:  "",		    //Controllo durata (per non ripetere la stessa durata consecutivamente)
			durataC: "",			//Durata della chiave
			stampaD: false,			//Serve a gestire la stampa della durata (la aggiunge se è diversa dalla prec)
			ott: "",				//Controllo ottava (per non ripetere la stessa ottava più volte)
			battuta: "undefined",   //Identificazione battuta precedente battuta
			stanghetta: 0,			//Indice per array stanghette[]
			trave: false,			//Indica se è presente la trave
			travePrec: false,		//Indica se c'è la trave nella posizione prima
			traveBbox: "",			//Controllo trave
		}

        //Ciclo per ogni pentagramma
        for (var p = 0; p < curScore.nstaves; p++) {
			cursor.staffIdx = p
			cursor.rewind(0)
			testo += "------Staff " + (p+1) + "------\n"

			//Ciclo per ogni voce
			for (var v = 0; v < 4; v++) {
				cursor.voice = v
				cursor.rewind(0)

				if (cursor.element != null) {
					testo += "Voice-" + (v+1) + ": " + getChiave(p) + " " + getArmChiave(curScore.keysig) + " " + getMetro(stato) + " " + " ";

					// Controllo durata (per non ripetere la stessa durata consecutivamente)
					stato.durata = getDurata(cursor.element.duration.numerator / cursor.element.duration.denominator);
					testo += stato.durata

					// Controllo gruppo irregolare (indica la presenza o meno di un gruppo irregolare)
					var tuplet = false;
					var indT = 0		// Indice interno del gruppo irregolare
					var numNoteT = 0	// Indica gli elementi che compongono il gruppo irregolare
					var fineT = false	// Controllo stampa fine gruppo irregolare

					// inizializzo battuta
					stato.battuta = cursor.measure.bbox
					var numBattuta = 1

					do {
						var curElement = cursor.element;
						// se il pezzo inizia con una stanghetta
						if (stanghette[0] && stato.stanghetta == 0) {
							testo += stanghette[1][0] + " "
							stato.stanghetta += 1
						}
						
						//skip controllo successivo su battuta di intera pausa
						var skip = false

						// se è cambiata la battuta
						if(cursor.measure.bbox != stato.battuta) {
							//se c'era trave
							if (stato.travePrec) {
								//chiudo la travatura
								testo += "} "

								//reset valori iniziali di trave
								stato.trave = false
								stato.numeroDiTravi = 0
								stato.travePrec = false
							}

							stato.battuta = cursor.measure.bbox

							testo += stanghette[1][stato.stanghetta] + " "
							stato.stanghetta += 1

							//incremento battuta
							numBattuta += 1

							skip = true
						}

						//Durata attuale
						var durata2 = getDurata(curElement.duration.numerator / curElement.duration.denominator);	//Durata espressa in Plaine & Easie Code
						var durataC2 = curElement.duration.numerator / curElement.duration.denominator;				//Durata espressa sotto forma di frazione

						//Gestione battuta di intera pausa, inserisce la stanghetta e aumenta l'indice dell'array stanghette[]
						if (curElement.type == Element.REST && !skip && numBattuta!=1) {
							if (stato.durataC <= durataC2 ) {
								testo += stanghette[1][stato.stanghetta] + " "
								stato.stanghetta += 1

								numBattuta += 1
							}
						}

						if (stato.durata !== durata2) {
							//Se la durata è diversa dalla precedente aggiorno "stato.durata"
							stato.durata = durata2;
							stato.stampaD = true;
						}
						
						// ------- GRUPPO IRREGOLARE START -------
						if (curElement.tuplet != null || tuplet) {
							if (indT == 0) {
								tuplet = true
								var durataT = getDurata(curElement.tuplet.duration.numerator / curElement.tuplet.duration.denominator);

								testo += durataT + " (";

								// Conteggio elementi in gruppo irregolare
								numNoteT = curElement.tuplet.elements.length;
							}
							// mi segno che la prima nota l'ho processata
							indT += 1
						}
						// ------- GRUPPO IRREGOLARE END -------

						// ------- TRAVI START -------
						// Se è prensete la trave
						if (curElement.beam) {
							// Controllo che non sia cambiata
							if (curElement.beam.bbox != stato.traveBbox) {
								// Se sono qui è cambiata

								// Chiudo vecchia trave se c'è
								if (stato.trave) {
									testo += "} "
								}

								// Apro nuova trave
								stato.traveBbox = curElement.beam.bbox
								stato.trave = true

								testo += "{"

								// TravePrec sarà la var per controllare se prima era presente una trave
								stato.travePrec = true
							}
						// Se prima c'era la trave devo chiuderla
						} else if (stato.travePrec) {
							testo += "} "
							
							stato.trave = false
							stato.travePrec = false
						}
						// ------- TRAVI END -------

						// Controllo per stampare la fine del gruppo irregolare
						if (fineT) {
							testo += ";" + numNoteT + ") ";

							// reset parametri
							fineT = false
							numNoteT = 0
						}

						// ------- DURATA + NOTE + PAUSE START -------
						if (stato.stampaD) {
							testo += stato.durata;
						}

						if (curElement.type == Element.CHORD) {
							//Se è un accordo
							testo += accordo(curElement.notes, stato)
						} else if (curElement.type == Element.REST) {
							//Se è una pausa che non prende l'intera battuta
							testo += "-";
						}
						testo += " "
						// ------- DURATA + NOTE + PAUSE END -------

						// ------- LEGATURA DI VALORE -------
						if (curElement.type == Element.CHORD && curElement.notes.length == 1 && curElement.notes[0].tieForward) {
							testo += "+"
						}

						// ------- FINE GRUPPO IRREGOLARE START -------
						if (curElement.tuplet != null || tuplet) {
							if (curElement.tuplet != null && indT == curElement.tuplet.elements.length) {
								fineT = true;
								
								//reset parametri
								indT = 0
								tuplet = false
							}
						}
						// ------- FINE GRUPPO IRREGOLARE END -------

						//Serve a gestire la stampa della durata (la aggiunge se è diversa dalla prec)
						stato.stampaD = false;
					}
					while (cursor.next())

					//Gestione ultima trave
					if (stato.trave) {
						testo += "} "
					}

					//reset valori iniziali
					stato.stanghetta = 0
					stato.trave = false
					stato.travePrec = false
					stato.ott = ""

					//Gestione ultima stanghetta
					testo += stanghette[1][stanghette[1].length - 1] + " "

					//Gestione più voci (Voice)
					testo += "\n"
				}
			}

			//Gestione più pentagrammi (Staff)
			testo += "\n";
        }

		return testo
    }

    onRun: {
    }
}