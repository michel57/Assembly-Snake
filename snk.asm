;--------------------------------------------------------
	TITLE	snake v0.3
;--------------------------------------------------------
CSEG SEGMENT
	ASSUME CS:CSEG, DS:CSEG, ES:CSEG
	ORG 100H
	.386
	
	
	
; +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- Données -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+


teteX equ 160
teteY equ 100
couleurmur equ 9
couleurobjet equ 4
couleurserpent equ 2
couleur2 db ?  ; couleur pixel à comparer
compt dw ?
niveau dw ?


; +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- Code -+-+-+-+-+-+-+-+-+-+-+-+-+-+

main:

MOV niveau, 2

;   ecran en mode graphique 320*200

MOV AX,13H     
INT 10H

; menu

MOV DX, OFFSET mess
MOV AH, 9
INT 21H

; choix menu

MOV AH, 0  ; recuperation touche
INT 16H

CALL choix

choix proc
	
CMP AL, 'j'
JE SHORT JEU
CMP AL, 'c'
JE CREDIT
CMP AL, 'a'
JE COMMANDES
CMP AL, 'h'
JE HISTOIRE
CMP AL, 'q'
JE SHORT fin
JMP choix

fin: 
MOV AH, 4CH
INT 21H

choix endp

JEU proc
	
;   ecran en mode graphique 320*200

MOV AX,13H     
INT 10H

; dessin cadre haut

MOV CX, 10+300  ; pos premier pixel, longueur
MOV DX, 20     ; pos ligne
MOV AL, 9     ; couleur bleu

cadreh: 

MOV AH, 0CH    ; ecrire pixel 
INT 10H

DEC CX
CMP CX, 10
JA cadreh
   
; dessin cadre bas: 

MOV CX, 10+300 ; pos 1er pix, longueur
MOV DX, 180   ; pos ligne
MOV AL, 9    ; bleu 

cadreb:

MOV AH, 0CH    ; ecrire pixel
INT 10H

DEC CX			; decalage pour ecriture
CMP CX, 10
JA cadreb

; dessin cadre gauche: 

MOV CX, 10  ; pos colonne
MOV DX, 180  ; pos ligne
MOV AL, 9    ; bleu

cadreg:

MOV AH, 0CH    ; ecriture pixel
INT 10H

DEC DX		; decalage pour ecriture
CMP DX, 19
JA cadreg
 

; dessin cadre droite: 

MOV CX, 310  ; pos colonne
MOV DX, 179  ;pos ligne
MOV AL, 9     ; bleu 

cadred:

MOV AH, 0CH    ; ecriture pixel
INT 10H

DEC DX   	; decalage pour ecriture
CMP DX, 19
JA cadred

CALL NIVEAU1

; ecriture tete serpent

MOV AH, 0CH
MOV CX,teteX
MOV DX,teteY
MOV AL, 2
INT 10h



boucle:

CALL touchee  ; appel module des touches


JMP boucle

; +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- Modules -+-+-+-+-+-+-+-+-+-+-+-+

touchee proc


; recuperation de touche

recuperation_touche:

MOV AL, 0
INT 16H
JMP touche


; comparaison touche code ascii

touche:

CMP AL, '8'
JE SHORT haut
CMP AL, '2'
JE SHORT bas
CMP AL, '4'
JE SHORT gauche
CMP AL, '6'
JE SHORT droite
CMP AL, 'q'
JE SHORT fin
JMP touchee

; deplacement haut

haut:

CALL lecture_pixel2h

MOV AH, 0CH
SUB DX, 1
MOV AL, 2
INT 10H

ret

;deplacement bas

bas:

CALL lecture_pixel2b

MOV AH, 0CH
ADD DX, 1
MOV AL, 2
INT 10H

ret

;deplacement gauche

gauche:

CALL lecture_pixel2g

MOV AH, 0CH
SUB CX, 1
MOV AL, 2
INT 10H

ret

;deplacement droite

droite:

CALL lecture_pixel2d

MOV AH, 0CH
ADD CX, 1
MOV AL, 2
INT 10H

ret

;quitter le programme

fin:

MOV AH, 4CH
INT 21H

ret

touchee endp

; modules lecture pixel suivant la direction voulue.

;gauche

lecture_pixel2g proc
	
	PUSHA
	MOV AH, 0DH
	MOV BH, 0
	DEC CX
	MOV AL, couleur2   
	INT 10H
	
	
	CALL comp_couleur_pixel
	POPA
	RET
	
lecture_pixel2g endp

;droite

lecture_pixel2d proc
	
	PUSHA
	MOV AH, 0DH
	MOV BH, 0
	INC CX
	MOV AL, couleur2
	INT 10H
	
	
	CALL comp_couleur_pixel
	POPA
	RET

lecture_pixel2d endp

;haut

lecture_pixel2h proc
	
	PUSHA
	MOV AH, 0DH
	MOV BH, 0
	DEC DX
	MOV AL, couleur2
    INT 10H
    
	
	CALL comp_couleur_pixel
POPA
	RET
	
lecture_pixel2h endp

;bas

lecture_pixel2b proc
	
	PUSHA
	MOV AH, 0DH
	MOV BH, 0
	INC DX
	MOV AL, couleur2
    INT 10H
  
	
	CALL comp_couleur_pixel
	POPA
	RET
	
lecture_pixel2b endp

; module comparaison des couleurs des 2 pixels adéquats

comp_couleur_pixel proc
	
	CMP AL, couleurserpent
	MOV BH, 0
	JE MORT
	
	CMP AL, couleurobjet
	MOV BH, 0
	JE compteur
		
	CMP AL, couleurmur
	MOV BH, 0
	JE FUITE
	
	ret
	
comp_couleur_pixel endp

compteur proc

DEC compt
CMP compt, 0
JE GAGNE

ret

compteur endp


NIVEAU1 proc
	
MOV compt, 5

; ecriture 5 objets

MOV AH, 0CH
MOV CX, 190
MOV DX, 60
MOV AL, 4
INT 10H

MOV AH, 0CH
MOV CX,150
MOV DX,90
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,190
MOV DX,50
MOV AL, 4
INT 10h
	
MOV AH, 0CH
MOV CX,359
MOV DX,150
MOV AL, 4
INT 10h
	
MOV AH, 0CH
MOV CX,245
MOV DX,87
MOV AL, 4
INT 10h
		
	ret

NIVEAU1 endp

GAGNE proc
	
;ecran en mode graphique 320*200

MOV AX,13H     
INT 10H

; laisser en commentaire si un seul niveau !

DEC niveau
CMP niveau, 3
JMP JEU2
CMP niveau, 2
JMP JEU3
CMP niveau, 1
JMP JEU4
CMP niveau, 0
JZ gagnee

; afficher message

gagnee:

MOV DX, OFFSET messG
MOV AH, 9
INT 21H

MOV AH, 0H
INT 16h

recuperation_touche:

MOV AL, 0
INT 16H
JMP toucheg


; comparaison touche 

toucheg:

CMP AL, 'j'
JE  JEU
CMP AL, 'q'
JE  fing

fing:

;quitter le jeu

MOV AH, 4CH
INT 21H
	
ret	

GAGNE endp	

MORT proc
	
;ecran en mode graphique 320*200

MOV AX,13H     
INT 10H

; afficher message

MOV DX, OFFSET messm
MOV AH, 9
INT 21H

; attente caractère

MOV AH, 00H
INT 16H
JMP touchem

; comparaison touche 

touchem:

CMP AL, 'j'
JE  main
CMP AL, 'q'
JE  finq
JMP touchem

finq:

; afficher message

MOV DX, OFFSET messf
MOV AH, 9
INT 21H

;attente appui touche

MOV AH, 0H
INT 16H

;quitter le jeu

MOV AH, 4CH
INT 21H

MORT endp

FUITE proc
	
;ecran en mode graphique 320*200

MOV AX,13H     
INT 10H

; afficher message

MOV DX, OFFSET messfuite  
MOV AH, 9
INT 21H
;attente touche
MOV AH, 0H
INT 16H

;attente touche
MOV AH, 0H
INT 16H

MOV DX, OFFSET messfuite2  
MOV AH, 9
INT 21H

;attente touche
MOV AH, 0H
INT 16H

;retour au debut du jeu

JMP JEU



FUITE endp

affiche_COMPTE proc
	
;   ecran en mode graphique 320*200

MOV AX,13H     
INT 10H

; afficher compteur

MOV DX, compt
MOV AH, 9
INT 21H

;attente caractère

MOV AH, 0H
INT 16H

RET 

affiche_COMPTE endp

JEU endp

CREDIT proc
	
	
	
;   ecran en mode graphique 320*200

MOV AX,13H     
INT 10H

; afficher message

MOV DX, OFFSET message
MOV AH, 9
INT 21H

;attente caractère

MOV AH, 0H
INT 16H

;retour au menu
JMP main

CREDIT endp

COMMANDES proc
	
;ecran en mode graphique 320*200

MOV AX,13H     
INT 10H

; afficher message

MOV DX, OFFSET messc
MOV AH, 9
INT 21H

;attente caractère

MOV AH, 0H
INT 16H

;retour au menu
JMP main

COMMANDES endp

HISTOIRE proc
	
	;ecran en mode graphique 320*200

MOV AX,13H     
INT 10H

; afficher message

MOV DX, OFFSET messh
MOV AH, 9
INT 21H

;attente caractère

MOV AH, 0H
INT 16H

;suite histoire
CALL HISTOIRE2
	
HISTOIRE endp

HISTOIRE2 proc
	
	;ecran en mode graphique 320*200

MOV AX,13H     
INT 10H

; afficher message

MOV DX, OFFSET messh2
MOV AH, 9
INT 21H

;attente caractère

MOV AH, 0H
INT 16H

;retour au menu
JMP main
	
HISTOIRE2 endp

NIVEAU2 proc

;   ecran en mode graphique 320*200

MOV AX,13H     
INT 10H

MOV compt, 10D

MOV AH, 0CH
MOV CX,190
MOV DX,60
MOV AL, 4
INT 10h


MOV AH, 0CH
MOV CX,150
MOV DX,90
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,190
MOV DX,50
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,359
MOV DX,150
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,245
MOV DX,87
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,89
MOV DX,124
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,100
MOV DX,40
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,143
MOV DX,56
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,278
MOV DX,96
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,34
MOV DX,67
MOV AL, 4
INT 10h

ret

NIVEAU2 endp

JEU2 proc
	
MOV AX, 0
MOV BX, 0
MOV CX, 0
MOV DX, 0
MOV AL, 0
MOV AH, 0

;   ecran en mode graphique 320*200

MOV AX,13H     
INT 10H

; dessin cadre haut

MOV CX, 10+300  ; pos premier pixel, longueur
MOV DX, 20     ; pos ligne
MOV AL, 9     ; couleur bleu

cadreh: 

MOV AH, 0CH    ; ecrire pixel 
INT 10H

DEC CX
CMP CX, 10
JA cadreh
   
; dessin cadre bas: 

MOV CX, 10+300 ; pos 1er pix, longueur
MOV DX, 180   ; pos ligne
MOV AL, 9    ; bleu 

cadreb:

MOV AH, 0CH    ; ecrire pixel
INT 10H

DEC CX			; decalage pour ecriture
CMP CX, 10
JA cadreb

; dessin cadre gauche: 

MOV CX, 10  ; pos colonne
MOV DX, 180  ; pos ligne
MOV AL, 9    ; bleu

cadreg:

MOV AH, 0CH    ; ecriture pixel
INT 10H

DEC DX		; decalage pour ecriture
CMP DX, 19
JA cadreg
 

; dessin cadre droite: 

MOV CX, 310  ; pos colonne
MOV DX, 179  ;pos ligne
MOV AL, 9     ; bleu 

cadred:

MOV AH, 0CH    ; ecriture pixel
INT 10H

DEC DX   	; decalage pour ecriture
CMP DX, 19
JA cadred

CALL NIVEAU2

; ecriture tete serpent

MOV AH, 0CH
MOV CX,teteX
MOV DX,teteY
MOV AL, 2
INT 10h



boucle:

CALL touchee  ; appel module des touches


JMP boucle


ret

JEU2 endp

NIVEAU3 proc

MOV compt, 15
	
MOV AH, 0CH
MOV CX,190
MOV DX,60
MOV AL, 4
INT 10h


MOV AH, 0CH
MOV CX,150
MOV DX,90
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,190
MOV DX,50
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,359
MOV DX,150
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,245
MOV DX,87
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,89
MOV DX,124
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,100
MOV DX,40
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,143
MOV DX,56
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,278
MOV DX,96
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,34
MOV DX,67
MOV AL, 4
INT 10h
	
MOV AH, 0CH
MOV CX,65
MOV DX,110
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,123
MOV DX,92
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,157
MOV DX,123
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,178
MOV DX,145
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,250
MOV DX,56
MOV AL, 4
INT 10h

ret

NIVEAU3 endp

JEU3 proc
	
MOV AX, 0
MOV BX, 0
MOV CX, 0
MOV DX, 0
MOV AL, 0
MOV AH, 0

;   ecran en mode graphique 320*200

MOV AX,13H     
INT 10H

; dessin cadre haut

MOV CX, 10+300  ; pos premier pixel, longueur
MOV DX, 20     ; pos ligne
MOV AL, 9     ; couleur bleu

cadreh: 

MOV AH, 0CH    ; ecrire pixel 
INT 10H

DEC CX
CMP CX, 10
JA cadreh
   
; dessin cadre bas: 

MOV CX, 10+300 ; pos 1er pix, longueur
MOV DX, 180   ; pos ligne
MOV AL, 9    ; bleu 

cadreb:

MOV AH, 0CH    ; ecrire pixel
INT 10H

DEC CX			; decalage pour ecriture
CMP CX, 10
JA cadreb

; dessin cadre gauche: 

MOV CX, 10  ; pos colonne
MOV DX, 180  ; pos ligne
MOV AL, 9    ; bleu

cadreg:

MOV AH, 0CH    ; ecriture pixel
INT 10H

DEC DX		; decalage pour ecriture
CMP DX, 19
JA cadreg
 

; dessin cadre droite: 

MOV CX, 310  ; pos colonne
MOV DX, 179  ;pos ligne
MOV AL, 9     ; bleu 

cadred:

MOV AH, 0CH    ; ecriture pixel
INT 10H

DEC DX   	; decalage pour ecriture
CMP DX, 19
JA cadred

CALL NIVEAU3

; ecriture tete serpent

MOV AH, 0CH
MOV CX,teteX
MOV DX,teteY
MOV AL, 2
INT 10h



boucle:

CALL touchee  ; appel module des touches


JMP boucle


ret

JEU3 endp

NIVEAU4 proc
	
MOV compt, 20

MOV AH, 0CH
MOV CX,190
MOV DX,60
MOV AL, 4
INT 10h


MOV AH, 0CH
MOV CX,150
MOV DX,90
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,190
MOV DX,50
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,359
MOV DX,150
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,245
MOV DX,87
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,89
MOV DX,124
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,100
MOV DX,40
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,143
MOV DX,56
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,278
MOV DX,96
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,34
MOV DX,67
MOV AL, 4
INT 10h
	
MOV AH, 0CH
MOV CX,65
MOV DX,110
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,123
MOV DX,92
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,157
MOV DX,123
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,178
MOV DX,145
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,250
MOV DX,56
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,123
MOV DX,123
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,160
MOV DX,100
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,190
MOV DX,87
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,280
MOV DX,144
MOV AL, 4
INT 10h

MOV AH, 0CH
MOV CX,51
MOV DX,76
MOV AL, 4
INT 10h

ret

NIVEAU4 endp

JEU4 proc
	
MOV AX, 0
MOV BX, 0
MOV CX, 0
MOV DX, 0
MOV AL, 0
MOV AH, 0

;   ecran en mode graphique 320*200

MOV AX,13H     
INT 10H

; dessin cadre haut

MOV CX, 10+300  ; pos premier pixel, longueur
MOV DX, 20     ; pos ligne
MOV AL, 9     ; couleur bleu

cadreh: 

MOV AH, 0CH    ; ecrire pixel 
INT 10H

DEC CX
CMP CX, 10
JA cadreh
   
; dessin cadre bas: 

MOV CX, 10+300 ; pos 1er pix, longueur
MOV DX, 180   ; pos ligne
MOV AL, 9    ; bleu 

cadreb:

MOV AH, 0CH    ; ecrire pixel
INT 10H

DEC CX			; decalage pour ecriture
CMP CX, 10
JA cadreb

; dessin cadre gauche: 

MOV CX, 10  ; pos colonne
MOV DX, 180  ; pos ligne
MOV AL, 9    ; bleu

cadreg:

MOV AH, 0CH    ; ecriture pixel
INT 10H

DEC DX		; decalage pour ecriture
CMP DX, 19
JA cadreg
 

; dessin cadre droite: 

MOV CX, 310  ; pos colonne
MOV DX, 179  ;pos ligne
MOV AL, 9     ; bleu 

cadred:

MOV AH, 0CH    ; ecriture pixel
INT 10H

DEC DX   	; decalage pour ecriture
CMP DX, 19
JA cadred

CALL NIVEAU4

; ecriture tete serpent

MOV AH, 0CH
MOV CX,teteX
MOV DX,teteY
MOV AL, 2
INT 10h



boucle:

CALL touchee  ; appel module des touches


JMP boucle


ret

JEU4 endp

mess db ' ', 0DH, 0AH
db ' ', 0DH, 0AH
db ' ', 0DH, 0AH
db ' Bienvenue dans Snek v 0.0001 pre-alpha', 0DH, 0AH
db ' ', 0DH, 0AH
db ' ', 0DH, 0AH
db ' ', 0DH, 0AH
db ' ', 0DH, 0AH
db '<j> jouer', 0DH, 0AH
db ' ', 0DH, 0AH
db ' ', 0DH, 0AH
db '<a> aide sur les commandes', 0DH, 0AH
db ' ', 0DH, 0AH
db ' ', 0DH, 0AH
db '<h> histoire du  jeu et objectifs ', 0DH, 0AH
db ' ', 0DH, 0AH
db ' ', 0DH, 0AH
db '<c> credits', 0DH, 0AH
db ' ', 0DH, 0AH
db ' ', 0DH, 0AH
db '<q> quitter.', 0DH, 0AH, '$'

message db ' ', 0DH, 0AH
    db '           Ce jeu a ete realise par:', 0DH, 0AH
    db ' ', 0DH, 0AH
    db ' ', 0DH, 0AH
    db ' ', 0DH, 0AH
    db ' ', 0DH, 0AH
    db ' ', 0DH, 0AH
    db 'Kuhm Michel  ', 0DH, 0AH
    db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'Bon jeu !', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'Appuyez sur une touche pour revenir', 0DH, 0AH 
	db 'au menu...', 0DH, 0AH, '$'
	
messc db  ' ', 0DH, 0AH
    db '    Voici les commandes de jeu:', 0DH, 0AH
    db ' ', 0DH, 0AH
    db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db '<2> pour se diriger vers le bas', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db '<8> pour se diriger vers le haut ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db '<4> pour se diriger vers la gauche', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db '<6> pour se diriger vers la droite ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db '<q> pour quitter le programme.', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'Appuyez sur une touche pour revenir', 0DH, 0AH 
	db 'au menu...', 0DH, 0AH, '$'
	
messh db  ' ', 0DH, 0AH
    db '         												               ', 0DH, 0AH
    db ' ', 0DH, 0AH
    db ' ', 0DH, 0AH
    db ' ', 0DH, 0AH
	db 'Dans un monde domine par les pixels, ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'les serpents n ont desormais plus', 0DH, 0AH
	db 'le choix: ils doivent se battre !', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'Afin de recuperer leur monde envahi  ', 0DH, 0AH
	db 'par ces etres numeriques, ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'la seule chose qu il leur reste a faire ', 0DH, 0AH
	db 'est de tenter de les ...DETRUIRE... ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'tous jusqu au dernier!', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'Appuyez sur n importe quelle touche... ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH, '$'
	
	messh2 db  ' ', 0DH, 0AH
    
    db ' ', 0DH, 0AH
    db ' 													', 0DH, 0AH
    db ' ', 0DH, 0AH
	db 'Pour cela, un courageux serpent nomme...', 0DH, 0AH
	db 'Gilbert la vipere... ', 0DH, 0AH
	db 'va tenter de se dresser contre eux.', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'Afin de les detruire, une seule solution ', 0DH, 0AH
	db 'fut approuvee: tous les avaler ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'sans en oublier un seul.', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' La seule chose a laquelle tu dois ', 0DH, 0AH
	db 'faire attention Gilbert,   ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'c est de ne pas te mordre toi meme ', 0DH, 0AH 
	db 'car tu pourrai t empoisonner ! ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'Tu es desormais notre derniere chance ', 0DH, 0AH
	db 'pour contrer cette invasion numerique ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'Nous comptons sur toi et sur ton talent (ou pas...).', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'Appuyez sur une touche pour revenir', 0DH, 0AH
	db ' au menu...  ', 0DH, 0AH
	db ' ', 0DH, 0AH, '$'
	
messm db  ' ', 0DH, 0AH
    
    db ' ', 0DH, 0AH
    db ' 													', 0DH, 0AH
    db ' ', 0DH, 0AH
	db 'Vous avez echoue...', 0DH, 0AH
	db 'Gilbert la vipere... ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'vous etiez notre dernier espoir. ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'Dorenavant, rien ne pourra empecher ', 0DH, 0AH
	db 'la multiplication des pixels et...', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'l avenement du monde numerique !!', 0DH, 0AH
	db '   ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'Notre unique et dernier espoir serait', 0DH, 0AH
	db 'd utiliser notre machine ... ', 0DH, 0AH
	db '   ', 0DH, 0AH
	db 'a remonter le temps ! ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'Mais aurez vous le courage et la force ', 0DH, 0AH
	db 'de vaincre cette fois ci? ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'Si vous acceptez cette mission, appuyez ', 0DH, 0AH
    db 'sur <j> sinon, appuyez sur <q>', 0DH, 0AH
    db ' ', 0DH, 0AH, '$'
	
messf db  ' ', 0DH, 0AH
    
    db ' ', 0DH, 0AH
    db ' 													', 0DH, 0AH
    db ' ', 0DH, 0AH
	db 'Ainsi, vous avez ECHOUE', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'Par votre faute, les pixels', 0DH, 0AH
	db 'vont envahir notre monde actuel ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db '... et plus personne ne pourra sortir ', 0DH, 0AH
	db 'de chez lui, absorbe par les ordinateurs', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'et leurs pixels !', 0DH, 0AH
	db '   ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'Merci quand meme d avoir tente de nous  ', 0DH, 0AH
	db 'aider mais cela n aura pas ete suffisant.', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'Vous etes le maillon faible, Au revoir. ', 0DH, 0AH
    db ' ', 0DH, 0AH
    db ' ', 0DH, 0AH
    db 'Appuyez sur une touche pour vous enfuir ', 0DH, 0AH
    db 'de ce monde numerique! ', 0DH, 0AH, '$'

	
messfuite db  ' ', 0DH, 0AH
    
    db ' ', 0DH, 0AH
    db ' 													', 0DH, 0AH
    db ' ', 0DH, 0AH
	db 'Ainsi, vous etes lache...', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'Vous avez tente de deserter le combat', 0DH, 0AH
	db 'contre les pixels envahisseurs ! ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'Le monde reel risque ainsi d en payer  ', 0DH, 0AH
	db 'un lourd tribut...', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'Appuyez sur une touche pour la suite... ', 0DH, 0AH
	db ' ', 0DH, 0AH, '$'

messfuite2 db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'Vous apprendrez jeune Schnorkel qu on ne   ', 0DH, 0AH
	db 'fuit pas un combat comme cela ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'Muhahahahaha.... ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'Quoi que vous fassiez, ', 0DH, 0AH
	db 'qui que vous soyez', 0DH, 0AH
	db ' ', 0DH, 0AH
    db 'nous controlons les verticales ', 0DH, 0AH
    db 'et les  horizontales et vous  ', 0DH, 0AH
    db ' ', 0DH, 0AH
    db 'NE pouvez PAS vous echapper... ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
    db 'Appuyez sur une touche pour retourner', 0DH, 0AH
    db 'au  combat... ', 0DH, 0AH, '$'
    
messG db  ' ', 0DH, 0AH
    db '             Felicitations !', 0DH, 0AH
    db ' ', 0DH, 0AH
    db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'Vous avez vaincu ce monde numerique', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'qui nous harcelait depuis des annees  ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'Desormais victorieux, vous ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'pouvez retourner a la vie reelle :) ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db ' ', 0DH, 0AH
	db 'Appuyez sur une touche pour revenir', 0DH, 0AH 
	db 'au menu...', 0DH, 0AH, '$'

   
    
CSEG ends

end main

