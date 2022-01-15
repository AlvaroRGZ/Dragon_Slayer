% Practica prolog


/* SPIDER -- a sample adventure game, by David Matuszek.
   Consult this file and issue the command "start."  */

:- dynamic esta_en/2, estoy_en/1, vivo/1, vida/1. /* Needed by SWI-Prolog. */

/* This defines my current location. */

% este hecho representa nuetra situcion en el mapa

estoy_en(casa).

% Caminos entre los distintos lugares

camino(casa,     w, centro).
camino(centro,   w, herreria).
camino(centro,   s, casa).
camino(centro,   a, taberna).
camino(centro,   d, puerta).
camino(taberna,  d, centro).
camino(herreria, s, centro).
camino(puerta,   a, centro).

% localizacion de objetos en el mapa

esta_en(llave,      padre).
esta_en(cubo,       casa).
esta_en(cuerda,     taberna).
esta_en(padre,      taberna).
esta_en(dragon,     puerta).
esta_en(tirachinas, herreria).
esta_en(madre,      casa).
esta_en(espada,     mano).

% Agentes con vida

vivo(dragon).
vida(yo).

% Obtencion de objetos hacia el inventario

coger(X) :-
        esta_en(X, inventario),
        write('Ya lo tienes guardado en el inventario.'),
        nl.

coger(X) :-
        estoy_en(Lugar),
        esta_en(X, Lugar),
        retract(esta_en(X, Lugar)),
        assert(esta_en(X, inventario)),
        write('Has guardado '), 
        write(X),
        write(' en el inventario.'),
        nl.

coger(_) :-
        write('No lo encuentro por aqui...'),
        nl.

sostener(X) :-
        esta_en(X, mano),
        write('Ya lo tienes en la mano.'),
        nl.

sostener(X) :-
				esta_en(X, inventario),
				esta_en(Y, mano),
				retract(esta_en(X, inventario)),
				retract(esta_en(Y, mano))
				assert(esta_en(Y, inventario)),
        assert(esta_en(X, mano)),
				
        write('Ahora tienes'), nl,
        write(X), nl,
        write(' en las manos.'), nl.

sostener(_) :-
        write('No tienes eso en el inventario.'),
        nl.

% Soltar objetos del inventario

soltar(X) :-
        esta_en(X, inventario),
        estoy_en(Lugar),
        retract(esta_en(X, inventario)),
        assert(esta_en(X, lugar)),
        write('Has dejado caer '),
        write(X),
        write(' al suelo.'),
        nl.

soltar(_) :-
        write('No lo tienes en el inventario.'),
        nl.

% Funciones para movernos 

w :- ir(w).

s :- ir(s).

a :- ir(a).

d :- ir(d).
				
ir(Direccion) :-
				estoy_en(Aqui),
				camino(Aqui, Direccion, Destino),
				retract(estoy_en(Aqui)),
				assert(estoy_en(Destino)),
				mirar.

ir(_) :-
				write('No puedo ir por ahi.'),nl.




/* This rule tells how to look about you. */

mirar :-
        estoy_en(Lugar),
        describir(Lugar),
        nl,
        objetos_en(Lugar),
        nl.


/* These rules set up a loop to mention all the objects
   in your vicinity. */

objetos_en(Lugar) :-
        esta_en(X, Lugar),
        write('Aqui hay '), write(X), write(' .'), nl.

objetos_en(_) :- 
				write('Aqui no hay nada que pueda utilizar.'), nl.

/* These rules tell how to handle killing the lion and the spider. */

matar :-
        estoy_en(puerta),
				esta_en(pistola, mano),
        write('Empiezas a descargar tu ira sobre el dragon hasta que'), nl,
        write('te quedas sin agua... El dragon se ha quedado convertido'), nl,
        write('en una gran estatua de obsidiana humeante. Has conseguido'), nl,
        write('salvar al pueblo de ese monstruo.'), nl.

matar :-
				estoy_en(puerta),
				esta_en(espada, mano),
				vida(yo),
				retract(vida(yo)),
				retract(estoy_en(puerta)),
				assert(estoy_en(centro)),
        write('Avanzas hacia el dragon blandiendo la espada intendando '), nl,
        write('acercarte lo suficiente. El dragon se rie de ti y te '), nl,
        write('lanza una gran llamarada que casi te quema vivo. No ha '), nl,
        write('sido buena idea usar la espada. Corres despavorido hacia'),
        write(' el pozo del pueblo.'), nl.

matar :-
				estoy_en(puerta),
				esta_en(espada, mano),
        write('No has aprendido la leccion sobre no usar la espada '), nl,
        write('contra el dragon, asique el te la vuelve a explicar,'), nl,
        write('esta vez engullendote de un bocado. Has muerto.'), nl,
				morir.

/* This rule tells how to die. */

morir :-
        finalizar.


/* Under UNIX, the "halt." command quits Prolog but does not
   remove the output window. On a PC, however, the window
   disappears before the final output can be seen. Hence this
   routine requests the user to perform the final "halt." */

finalizar. :-
        nl,
        write('El juego ha acabado. Pulsa CTRL + D o escribe halt. para salir'),
        nl.


/* This rule just writes out game instructions. */

instrucciones :-
        nl,
        write('Juega utilizando los siguientes comandos:'), nl,
        write('empezar.                 -- Para comenzar el juego.'), nl,
        write('w.  s.  a.  d.           -- Para moverte en esa direccion.'), nl,
        write('coger(Objeto).           -- Para recoger un objeto.'), nl,
        write('soltar(Objeto).          -- Para dejar caer el objeto.'), nl,
        write('sostener(Objeto).        -- Para llevar el objeto en la mano.'), nl,
        write('matar.                   -- Para atacar a un enemigo.'), nl,
        write('mirar.                   -- Para mirar a tu alrededor.'), nl,
        write('Instrucciones.           -- Para volver a ver esta ayuda.'), nl,
        write('halt.                    -- Para parar y salir del juego.'), nl,
        nl.


/* This rule prints out instructions and tells where you are. */

e :-
        instrucciones,
        mirar.


/* These rules describe the various rooms.  Depending on
   circumstances, a room may have more than one description. */

describir(casa) :-
				write('┌───────────────────┬─────────────┬───────────────────┐'), nl,
				write('│░░░░░░░░░░░░░░░░░░░│┌───────────┐│░░░░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││           ││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││           ││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││           ││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││        -- ││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││           ││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('├───────────────────┴┴───────────┴┴───────────────────┤'), nl,
				write('│                          ^                          │'), nl,
				write('│                          |                          │'), nl,
				write('│     ┌─────┐              w                          │'), nl,
				write('│    ┌┘     └┐                                        │'), nl,
				write('│    │      o└┐                                       │'), nl,
				write('│    │       ┌┘                                       │'), nl,
				write('│    │      0│                                        │'), nl,
				write('│    └┐    ┌─┘                                        │'), nl,
				write('│    ┌┘   ┌┘                                          │'), nl,
				write('└────┴────┴───────────────────────────────────────────┘'), nl,
				write('zzz... zzz... RUUUUUAARGGG!!'), nl,
				write('QUE... QUE HA PASADO??'), nl,
				write('Estabas durmiendo placidamente cuando un estruendo te hace'), nl,
				write('saltar de la cama. Deberias salir de casa a ver que pasa.'), nl.


describir(centro) :-
        write('┌───────────────┬──────────────┬────────┬─────────────┐'), nl,
        write('│               │              │        │             │'), nl,
        write('│               │   HERRERIA   │        └─┐           │'), nl,
        write('│               └──────────────┘          └┐          │'), nl,
        write('│                                          │          │'), nl,
        write('│                                          │          │'), nl,
        write('├──────┐                             ──────┘          │'), nl,
        write('│      │              ┌───┐          ║║║║║║           │'), nl,
        write('│  B   │              │ ▒ │          ║║║║║║     🐉    │'), nl,
        write('│  A   │              └───┘          ║║║║║║           │'), nl,
        write('│  R   │                             ║║║║║║           │'), nl,
        write('│      │                o            ──────┐          │'), nl,
        write('├──────┘                                   │          │'), nl,
        write('│                                          │          │'), nl,
        write('│                ┌─────────────┐          ┌┘          │'), nl,
        write('│                │    CASA     │        ┌─┘           │'), nl,
        write('│                │             │        │             │'), nl,
        write('└────────────────┴─────────────┴────────┴─────────────┘'), nl,
        write('Estas en el centro de la ciudad.'), nl.

describir(puerta) :-
				write('┌───────────────────┬─────────────┬───────────────────┐'), nl,
				write('│                                                     │'), nl,
				write('│                                                     │'), nl,
				write('│                      DRAGONASO                      │'), nl,
				write('│                                                     │'), nl,
				write('│                                                     │'), nl,
				write('│                                                     │'), nl,
				write('│                                                     │'), nl,
				write('│                                                     │'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││═══════════││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││═══════════││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││═══════════││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││═══════════││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││═══════════││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││═══════════││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('├───────────────────┴┴───────────┴┴───────────────────┤'), nl,
				write('│                                                     │'), nl,
				write('└─────────────────────────────────────────────────────┘'), nl,
				write('Estas delante del gigantesco dragon, resopla llamaradas'), nl,
				write('y tiene pinta de estar muy cabreado. '), nl.

describir(herreria) :-
				write('┌───────────────────┬─────────────┬───────────────────┐'), nl,
				write('│░░░░░░░░░░░░░░░░░░░│┌───────────┐│░░░░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││           ││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││           ││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││           ││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││        -- ││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││           ││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('├───────────────────┴┴───────────┴┴───────────────────┤'), nl,
				write('│                          ^                          │'), nl,
				write('│                          |                          │'), nl,
				write('│     ┌─────┐              w                          │'), nl,
				write('│    ┌┘     └┐                                        │'), nl,
				write('│    │      o└┐                                       │'), nl,
				write('│    │       ┌┘                                       │'), nl,
				write('│    │      0│                                        │'), nl,
				write('│    └┐    ┌─┘                                        │'), nl,
				write('│    ┌┘   ┌┘                                          │'), nl,
				write('└────┴────┴───────────────────────────────────────────┘'), nl,
				write('Estas delante del gigantesco dragon, resopla llamaradas'), nl,
				write('y tiene pinta de estar muy cabreado. '), nl.

describir(closet) :-
        write('This is nothing but an old storage closet.'), nl.

describir(cave_entrance) :-
        write('You are in the mouth of a dank cave.  The exit is to'), nl,
        write('the south; there is a large, dark, round passage to'), nl,
        write('the east.'), nl.

describir(cave) :-
        alive(spider),
        at(ruby, in_hand),
        write('The spider sees you with the ruby and attacks!!!'), nl,
        write('    ...it is over in seconds....'), nl,
        die.

describir(cave) :-
        alive(spider),
        write('There is a giant spider here!  One hairy leg, about the'), nl,
        write('size of a telephone pole, is directly in front of you!'), nl,
        write('I would advise you to leave promptly and quietly....'), nl.

describir(cave) :-
        write('Yecch!  There is a giant spider here, twitching.'), nl.
				
describir(spider) :-
        alive(spider),
        write('You are on top of a giant spider, standing in a rough'), nl,
        write('mat of coarse hair.  The smell is awful.'), nl.

describir(spider) :-
        write('Oh, gross!  Youre on top of a giant dead spider!'), nl.