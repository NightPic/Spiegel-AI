# dt-g5

# Spiegel AI

## Beispielnutzung
Ich hoffe, ihr habt git schon mal benutzt. Hier sind ein paar Refresher:

1. Erstellt einen Ordner, in welches ihr das Repository klonen möchtet.
2. Navigiert im Terminal/CMD in diesen Ordner.
3. Klont das Repository mit dem Command:
```bash
git clone https://gitlab.oth-regensburg.de/vod32585/dt-g5.git
```
4. Ihr werdet nach euren Zugangsdaten gefragt. Einfach eintippen.
5. Jetzt könnt ihr an der repo arbeiten wie ihr möchtet.
6. Um eure Änderungen ins Repository zu pushen, müsst ihr diese zu erst adden:
```bash
git add filename.text documentation/documentation.tex
```
oder
```bash
git add .
```
falls ihr alle Änderungen hinzufügen wollt.
7. Mit
```bash
git status
```
könnt ihr noch mal überprüfen, welche Änderungen hinzugefügt werden.
8. Als nächstes commitet ihr die Änderungen mit
```bash
git commit -m "Aussagekräftiger Kommentar, der kurz beschreibt, was geändert wurde"
```
Wer keinen Kommentar schreibt, wird beim Metzner verpetzt (und von mir persönlich gehasst).
Wenn ihr das erste mal commitet, werdet ihr vermutlich gefragt, wer ihr seid. Da einfach
```bash
git config --global user.name "abc12345"
```
angeben. Mit der E-Mail funktioniert das denke ich nicht.
9. Als letztes müsst ihr die Änderungen pushen. Ihr könnt das in eine bestimmte branch pushen, oder in die main branch. Alles, was nicht sourcecode ist, wird wahrscheinlich keine extra branch brauchen.
```bash
git push origin main
```
Hier müsst ihr wieder eure Zugangsdaten eingeben.

## Dokumentation
In der documentation directory bitte NUR die documentation.tex und documentation.pdf hochladen. Bitte nicht die anderen Dateien, die beim Kompilieren erzeugt werden. TBD in gitignore hinzufügen.

## Organisation
Bitte auf saubere directory-Strukturen achten, die Sinn ergeben. Bitte alles so intuitiv hinzufügen, dass man alles schnell finden kann. Keinen Sourcecode in documentations, etc.

Auch darauf achten, dass directories und Dateinamen alle in englischer Sprache sind, damit es einheitlich bleibt. Falls wir in der Abgabe etwas umbenennen müssen, dann können wir das im Nachinein tun.

Bitte bei JEDEM commit einen Kommentar hinzufügen. Deutsch oder Englisch ist egal. Ganze Sätze sind fast immer sinnvoll. Hier ein paar Beispiele:

### DON'Ts
"Added something"

"Fixed problem"

"Läuft wieder"

"Merged branch ..."

### DOs
"ADDED function that increases speed of facial recognition"

"REMOVED functionality of genital rating"

"FIXED Algorithmus, der die verschiedenen Wettervorhersagen sortiert"

"ADDED a couple of paragraphs in the documentation under the section 'Einführung'"
