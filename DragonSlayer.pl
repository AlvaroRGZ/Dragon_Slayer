/*
Álvaro Rodríguez Gómez
Inteligencia artificial.
Universidad de La Laguna. 2021 - 2022
Juego simple en prolog
*/

:- dynamic esta_en/2, estoy_en/1, vivo/1, vida/1, tanque_arma/1. /* Para SWI-Prolog */

% Este hecho representa nuetra situcion en el mapa

estoy_en(intro).

% Caminos entre los distintos lugares

%Caminos zona sur
camino(intro,    w, centro):- describir(intro_centro).
camino(casa,     w, centro).
camino(casa,     a, hab1).
camino(casa,     d, hab2).
camino(hab1,     d, casa).
camino(hab2,     a, casa).

%Caminos zona centro
camino(centro,   w, herreria) :- esta_en(llave, mano), quitar_objeto(llave, puerta_herreria).
camino(centro,   w, herreria) :- esta_en(llave,puerta_herreria).
camino(centro,   w, herreria) :- esta_en(llave, inventario), describir(sacar_llave_herreria), !, fail.
camino(centro,   w, herreria) :- describir(no_entrar_herreria), !, fail.
camino(centro,   s, casa).
camino(centro,   a, taberna).
camino(centro,   d, puerta).

camino(centro,   e, pozo) :- 
	esta_en(cubo, inventario),
	esta_en(cuerda, inventario),
	retract(tanque_arma(vacio)),
	assert(tanque_arma(lleno)),
	write('Utilizaste la cuerda y el cubo para sacar agua'), nl,
	write('y cargar la pistola de agua. Tiembla dragon...'), nl.

camino(centro,   e, pozo) :- 
	tanque_arma(lleno),
	write('Creo que con este agua me sobra para acabar con'), nl,
	write('el dragon.'), nl.

camino(centro,   e, pozo) :- 
	write('El pozo parece vacio pero al fondo parece que '), nl,
	write('aun queda agua, quizas podria ingeniarmelas para'), nl,
	write('conseguir agua.'), nl.

camino(pozo,     a, centro).

camino(taberna,  d, centro).
camino(taberna,  e, taberna) :-
	esta_en(llave, padre), 
	write('Aqui tienes la llave de la herreria, justo me pillas '), nl,
	write('con un asunto del trabajo...'), nl,
	retract(esta_en(llave, padre)),
	assert(esta_en(llave, inventario)).

camino(taberna,  e, taberna) :- 
	esta_en(llave, inventario),
	write('Dejame ya en paz que estoy estudiando...'), nl.

camino(herreria, s, centro).
camino(puerta,   a, centro).

% Localizacion de objetos en el mapa

esta_en(llave,      padre).
esta_en(cubo,       hab1).
esta_en(cuerda,     hab2).
esta_en(padre,      taberna).
esta_en(dragon,     puerta).
esta_en(pistola,    herreria).
esta_en(espada,     taberna).

% Agentes con vida

vivo(dragon).
vida(yo).

%Estado de objetos

tanque_arma(vacio).

% Obtencion de objetos hacia el inventario

coger(X) :-
        esta_en(X, inventario), !,
        write('Ya lo tienes guardado en el inventario.'),
        nl.

coger(X) :-
        estoy_en(Lugar),
        esta_en(X, Lugar), !,
        retract(esta_en(X, Lugar)),
        assert(esta_en(X, inventario)),
        write('Has guardado '), 
        write(X),
        write(' en el inventario.'),
        nl.

coger(_) :-
        write('No lo encuentro por aqui...'),
        nl, 
				fail.

% Colocar objeto en la mano para usarlo

sostener(X) :-
        esta_en(X, mano), !,
        write('Ya lo tienes en la mano.'),
        nl.

sostener(X) :-
				esta_en(X, inventario), 
				esta_en(Y, mano),
				retract(esta_en(X, inventario)),
				retract(esta_en(Y, mano)),
				assert(esta_en(Y, inventario)),
        assert(esta_en(X, mano)),
				
        write('Ahora tienes '),
        write(X),
        write(' en las manos.'), !, nl.

sostener(X) :-
				esta_en(X, inventario), 
				retract(esta_en(X, inventario)),
        assert(esta_en(X, mano)),
        write('Ahora tienes '), 
        write(X),
        write(' en las manos.'), !, nl.

sostener(_) :-
        write('No tienes eso en el inventario.'),
        nl,
				fail.

% Colocar objeto de la mano al inventario

%guardar(X) :-
%				esta_en(X, inventario),
%				write('Ya lo tienes en el inventario.'), !,
%				nl.
				
guardar :-
				esta_en(X, mano),
				retract(esta_en(X, mano)),
				assert(esta_en(X, inventario)),
				
				write('Has guardado '),
				write(X),
				write(' en el inventario.'), !, nl.
	
guardar :-
				write('No tienes nada en la mano.'), nl.

% Soltar objetos del inventario

soltar(X, Lugar) :-
        esta_en(X, inventario),
        estoy_en(Lugar),
        retract(esta_en(X, inventario)),
        assert(esta_en(X, lugar)),
        write('Has dejado caer '),
        write(X),
        write(' al suelo.'), !,
        nl.

soltar(X) :-
        esta_en(X, inventario), 
        estoy_en(Lugar),
        retract(esta_en(X, inventario)),
        assert(esta_en(X, Lugar)),
        write('Has dejado caer '),
        write(X),
        write(' al suelo.'), !,
        nl.

soltar(_) :-
        write('No lo tienes en el inventario.'),
        nl, !,
				fail.

% Quita los objetos de la mano o el inventario al usarlos

quitar_objeto(X, Lugar) :-
				esta_en(X, mano),
				retract(esta_en(X, mano)),
        assert(esta_en(X, Lugar)), !.

quitar_objeto(X) :-
				esta_en(X, mano), !,
        estoy_en(Y),
				retract(esta_en(X, mano)),
        assert(esta_en(X, Y)), !.

% Para ver el inventario y lo que tiene en las manos

ver_inventario :- 
				write('INVENTARIO: '), !,
				objetos_en(inventario).

ver_mano :- 
				esta_en(X, mano), !,
				write('EN MANO: '),
				write(X).

ver_mano :-
	write('No tengo nada en la mano'),
	fail.	

% Funciones para movernos e interactuar con el entorno.

w :- ir(w).

s :- ir(s).

a :- ir(a).

d :- ir(d).

e :- ir(e).
				
m :- mirar.

i :- ver_inventario.

g :- ver_mano.

c(Objeto) :- coger(Objeto).

f(Objeto) :- sostener(Objeto).

ir(Direccion) :-
				estoy_en(Aqui),
				camino(Aqui, Direccion, Destino),
				retract(estoy_en(Aqui)),
				assert(estoy_en(Destino)), !,
				mirar.

ir(_) :-
				write('No puedo ir por ahi.'),nl.

/* This rule tells how to look about you. */

mirar :-
        estoy_en(Lugar), !,
        describir(Lugar),
        nl,
				write('Aqui hay: '),
        objetos_en(Lugar),
        nl.


/* These rules set up a loop to mention all the objects
   in your vicinity. */

objetos_en(Lugar) :-
				esta_en(X, Lugar), 
				write(X),
				write('  '),
				fail.

listar_objetos(Lugar) :-
				esta_en(X, Lugar), !,
				write(X),
				write(', ').

%objetos_en(_) :- 
%				write('Aqui no hay nada que pueda utilizar.'), nl.

/* These rules tell how to handle killing the lion and the spider. */

matar :-
	estoy_en(puerta),
	esta_en(pistola, mano),
	tanque_arma(lleno),
  write('Empiezas a descargar tu ira sobre el dragon hasta que'), nl,
  write('te quedas sin agua... El dragon se ha quedado convertido'), nl,
  write('en una gran estatua de obsidiana humeante. Has conseguido'), nl,
  write('salvar al pueblo de ese monstruo.'), !, nl.

matar :-
  estoy_en(puerta),
	esta_en(pistola, mano),
	tanque_arma(vacio),
	vida(yo),
	retract(vida(yo)),
  write('Te situas justo delante del monstruo apuntandole con la pistola,'), nl,
  write('esbozas una sonrisita y pulsas el gatillo!!'), nl,
  write('Oh... vaya... La pistola esta vacia... Ahora es al dragon a quien'), nl,
  write('se le escapa la sonrisita. Te da tiempo a correr hacia el centro'), nl,
  write('a buscar la manera de cargarla.'), !, nl.

matar :-
  estoy_en(puerta),
	esta_en(pistola, mano),
	tanque_arma(vacio),
  write('¿Como se te ocurre volver a hacer lo mismo?'), nl,
  write('Esta vez el dragon no te perdona y te come vivo.'), !, nl.

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
        write(' el pozo del pueblo.'), !, nl.

matar :-
				estoy_en(puerta),
				esta_en(espada, mano),
        write('No has aprendido la leccion sobre no usar la espada '), nl,
        write('contra el dragon, asique el te la vuelve a explicar,'), nl,
        write('esta vez engullendote de un bocado.'), nl,
				morir.

matar :-
				estoy_en(puerta),
        write('Buena idea la de ir a por el dragon a puñetazos,'), nl,
        write('la proxima vez que juegues piensa un poco mas.'), nl,
				morir.

% Funciones para terminar la partida

morir :-
	write('HAS MUERTO.'), nl,
  finalizar.

finalizar :-
        nl,
				write('FIN DE LA PARTIDA'),
        write('Pulsa CTRL + D o escribe halt. para salir'),
        nl.


/* Muestra las instrucciones del juego */

instrucciones :-
        nl,
        write('Juega utilizando los siguientes comandos:'), nl,
        write('em.                       -- Para comenzar el juego.'), nl,
        write('w.  s.  a.  d.           -- Para moverte en esa direccion.'), nl,
        write('coger(Objeto).           -- Para recoger un objeto.'), nl,
        write('soltar(Objeto).          -- Para dejar caer el objeto.'), nl,
        write('sostener(Objeto).        -- Para llevar el objeto en la mano.'), nl,
        write('guardar.                 -- Para guardar lo que tengas en la mano.'), nl,
        write('matar.                   -- Para atacar a un enemigo.'), nl,
        write('mirar.                   -- Para mirar a tu alrededor.'), nl,
        write('ver_inventario.          -- Para abrir el inventario.'), nl,
        write('ver_inventario.          -- Para abrir el inventario.'), nl,
        write('ver_mano.                -- Para ver lo que tienes en la mano.'), nl,
        write('Instrucciones.           -- Para volver a ver esta ayuda.'), nl,
        write('halt.                    -- Para parar y salir del juego.'), nl,
				write('El simbolo 🚶 representa donde estas en el mapa.'), nl,
        nl.

% sentencia para comenzar el juego.

em :-
        instrucciones,
        mirar.

% Describen las escenas y donde nos encontramos.a

describir(intro) :-
				write('┌───────────────────┬─────────────┬───────────────────┐'), nl,
				write('│░░░░░░░░░░░░░░░░░░░│┌───────────┐│░░░░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││           ││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││           ││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││           ││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││        -- ││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││           ││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('├───────────────────┴┴───────────┴┴───────────────────┤'), nl,
				write('│                          ^                          │'), nl,
				write('│     ?   ?                |                          │'), nl,
				write('│   ! ┌─────┐              w                          │'), nl,
				write('│  ? ┌┘     └┐                                        │'), nl,
				write('│    │      o└┐  < HUH?                               │'), nl,
				write('│    │       ┌┘                                       │'), nl,
				write('│    │      0│                                        │'), nl,
				write('│    └┐    ┌─┘                                        │'), nl,
				write('│    ┌┘   ┌┘                                          │'), nl,
				write('└────┴────┴───────────────────────────────────────────┘'), nl,
				write('zzz... zzz... RUUUUUAARGGG!!'), nl,
				write('QUE... QUE HA PASADO??'), nl,
				write('Estabas durmiendo placidamente cuando un estruendo te hace'), nl,
				write('saltar de la cama. Deberias salir de casa a ver que pasa.'), nl.

describir(intro_centro) :-
				write('┌───────────────────┬─────────────┬───────────────────┐'), nl,
				write('│                          🐉                         │'), nl,
				write('│░░░░░░░░░░░░░░░░░░░│┌───────────┐│░░░░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││═══════════││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││═══════════││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││═══════════││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││═══════════││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││═══════════││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('├───────────────────┴┴───────────┴┴───────────────────┤'), nl,
				write('│     !   !                                           │'), nl,
				write('│   ! ┌─────┐                                         │'), nl,
				write('│  ! ┌┘     └┐                                        │'), nl,
				write('│    │      o└┐  < OH NOO                             │'), nl,
				write('│    │       ┌┘                                       │'), nl,
				write('│    │      0│                                        │'), nl,
				write('│    └┐    ┌─┘                                        │'), nl,
				write('│    ┌┘   ┌┘                                          │'), nl,
				write('└────┴────┴───────────────────────────────────────────┘'), nl,
				write('UN GRAN GIGANTESCO DRAGON ESTA RUGIENDO A LAS PUERTAS DEL PUEBLO!!'), nl,
				write('HE DE ENCONTRAR LA MANERA DE SALVAR A TODOS.'), nl.

describir(casa) :-
				write('┌────────────────┬─────┬───────┬─────┬────────────────┐'), nl,
				write('│░░░░░░░░░░░░░░░░│         W         │░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░│                   │░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░│                   │░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░HABITACION░░░│                   │░░░HABITACION░░░│'), nl,
				write('│░░░░░░░░1░░░░░░░│                   │░░░░░░░2░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░│                   │░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░─┤                   ├─░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░                         ░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░   A         🚶         D  ░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░                         ░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░─┤                   ├─░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░│                   │░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░│                   │░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░│                   │░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░│                   │░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░│                   │░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░│                   │░░░░░░░░░░░░░░░░│'), nl,
				write('└────────────────┴─────┴───────┴─────┴────────────────┘'), nl,
				write('Mi bonita casa... ¿Habra algo por aqui que me sirva?'), nl.

describir(hab1) :-
				write('┌────────────────┬─────┬───────┬─────┬────────────────┐'), nl,
				write('│                │                   │                │'), nl,
				write('│                │                   │                │'), nl,
				(esta_en(cubo, hab1) -> write('│        🧺       │                   │                │');
				                        write('│                │                   │                │')), nl,
				write('│                │                   │                │'), nl,
				write('│                │                   │                │'), nl,
				write('│                │                   │                │'), nl,
				write('│               ─┤                   ├─               │'), nl,
				write('│                                                     │'), nl,
				write('│      🚶        D                                    │'), nl,
				write('│                                                     │'), nl,
				write('│               ─┤                   ├─               │'), nl,
				write('│                │                   │                │'), nl,
				write('│                │                   │                │'), nl,
				write('│                │                   │                │'), nl,
				write('│                │                   │                │'), nl,
				write('│                │                   │                │'), nl,
				write('│                │                   │                │'), nl,
				write('└────────────────┴─────┴───────┴─────┴────────────────┘'), nl,
				write('Mi habitacion.'), nl.

describir(hab2) :-
				write('┌────────────────┬─────┬───────┬─────┬────────────────┐'), nl,
				write('│                │                   │                │'), nl,
				write('│                │                   │                │'), nl,
				write('│                │                   │                │'), nl,
				write('│                │                   │                │'), nl,
				write('│                │                   │                │'), nl,
				write('│                │                   │                │'), nl,
				write('│               ─┤                   ├─               │'), nl,
				write('│                                                     │'), nl,
				write('│                                     A       🚶      │'), nl,
				write('│                                                     │'), nl,
				write('│               ─┤                   ├─               │'), nl,
				write('│                │                   │                │'), nl,
				(esta_en(cuerda, hab2) -> write('│                │                   │         📿     │');
				                          write('│                │                   │                │')), nl,
				write('│                │                   │                │'), nl,
				write('│                │                   │                │'), nl,
				write('│                │                   │                │'), nl,
				write('│                │                   │                │'), nl,
				write('└────────────────┴─────┴───────┴─────┴────────────────┘'), nl,
				write('La habitacion de mis padres.'), nl.

describir(centro) :-
        write('┌───────────────┬──────────────┬────────┬─────────────┐'), nl,
        write('│               │              │        │             │'), nl,
        write('│               │   HERRERIA   │        └─┐           │'), nl,
        write('│               └──────────────┘          └┐          │'), nl,
        write('│                      W                   │          │'), nl,
        write('│                                          │          │'), nl,
        write('├──────┐               POZO          ──────┘          │'), nl,
        write('│      │            E ┌───┐          ║║║║║║           │'), nl,
        write('│  B   │              │ ▒ │          ║║║║║║     🐉    │'), nl,
        write('│  A   │ A            └───┘       D  ║║║║║║           │'), nl,
        write('│  R   │                             ║║║║║║           │'), nl,
        write('│      │        🚶                   ──────┐          │'), nl,
        write('├──────┘                                   │          │'), nl,
        write('│                       S                  │          │'), nl,
        write('│                ┌─────────────┐          ┌┘          │'), nl,
        write('│                │    CASA     │        ┌─┘           │'), nl,
        write('│                │             │        │             │'), nl,
        write('└────────────────┴─────────────┴────────┴─────────────┘'), nl,
        write('Estas en el centro de la ciudad.'), nl.

describir(pozo) :-
        write('┌───────────────┬──────────────┬────────┬─────────────┐'), nl,
        write('│               │              │        │             │'), nl,
        write('│               │   HERRERIA   │        └─┐           │'), nl,
        write('│               └──────────────┘          └┐          │'), nl,
        write('│                                          │          │'), nl,
        write('│                                          │          │'), nl,
        write('├──────┐                             ──────┘          │'), nl,
        write('│      │              ┌───┐          ║║║║║║           │'), nl,
        write('│  B   │        A   🚶│ ▒ │          ║║║║║║     🐉    │'), nl,
        write('│  A   │              └───┘          ║║║║║║           │'), nl,
        write('│  R   │                             ║║║║║║           │'), nl,
        write('│      │                             ──────┐          │'), nl,
        write('├──────┘                                   │          │'), nl,
        write('│                                          │          │'), nl,
        write('│                ┌─────────────┐          ┌┘          │'), nl,
        write('│                │    CASA     │        ┌─┘           │'), nl,
        write('│                │             │        │             │'), nl,
        write('└────────────────┴─────────────┴────────┴─────────────┘'), nl,
        write('Estas justo delante del pozo. Pulsa d para volver al centro.'), nl.

describir(puerta) :-
				write('┌───────────────────┬─────────────┬───────────────────┐'), nl,
				write('│                                                     │'), nl,
				write('│                                                     │'), nl,
				write('│                          🐉                         │'), nl,
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
				write('│                          A                          │'), nl,
				write('└─────────────────────────────────────────────────────┘'), nl,
				write('Estas delante del gigantesco dragon, resopla llamaradas'), nl,
				write('y tiene pinta de estar muy cabreado. '), nl.

describir(no_entrar_herreria) :-
				write('┌───────────────────┬─────────────┬───────────────────┐'), nl,
				write('│░░░░░░░░░░░░░░░░░░░│┌───────────┐│░░░░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││           ││░░░┌─────────┐░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││           ││░░░│Estoy en │░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││           ││░░░│el bar.  │░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││        -- ││░░░└─────────┘░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││           ││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('├───────────────────┴┴───────────┴┴───────────────────┤'), nl,
				write('│                                                     │'), nl,
				write('│                                                     │'), nl,
				write('│     ┌─────┐                                         │'), nl,
				write('│    ┌┘     └┐    < Este como siempre...              │'), nl,
				write('│    │      o└┐                                       │'), nl,
				write('│    │       ┌┘                                       │'), nl,
				write('│    │      _│                                        │'), nl,
				write('│    └┐    ┌─┘                                        │'), nl,
				write('│    ┌┘   ┌┘                                          │'), nl,
				write('└────┴────┴───────────────────────────────────────────┘'), nl,
				write('Que podía esperarme? mi padre a esta hora siempre se va'), nl,
				write('a tomar un descansito... Tendre que ir a pedirle la '), nl,
				write('llave de la herreria.'), nl.

describir(sacar_llave_herreria) :-
				write('┌───────────────────┬─────────────┬───────────────────┐'), nl,
				write('│░░░░░░░░░░░░░░░░░░░│┌───────────┐│░░░░░░░░░░░░░░░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││           ││░░░┌─────────┐░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││           ││░░░│Estoy en │░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││           ││░░░│el bar.  │░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││        -- ││░░░└─────────┘░░░░░│'), nl,
				write('│░░░░░░░░░░░░░░░░░░░││           ││░░░░░░░░░░░░░░░░░░░│'), nl,
				write('├───────────────────┴┴───────────┴┴───────────────────┤'), nl,
				write('│                                                     │'), nl,
				write('│                                                     │'), nl,
				write('│     ┌─────┐                                         │'), nl,
				write('│    ┌┘     └┐    < Ni con un dragon amenazando el    │'), nl,
				write('│    │      o└┐     pueblo me lo tomo en serio...     │'), nl,
				write('│    │       ┌┘                                       │'), nl,
				write('│    │      _│                                        │'), nl,
				write('│    └┐    ┌─┘                                        │'), nl,
				write('│    ┌┘   ┌┘                                          │'), nl,
				write('└────┴────┴───────────────────────────────────────────┘'), nl,
				write('De poco sirve tener la llave en el bolsillo no? Antes'), nl,
				write('de entrar debes sacar la llave.'), nl.

describir(herreria) :-
				write('┌───────────┬─────────────────────────────┬───────────┐'), nl,
				write('├───────────┼─────────────────────────────┼───────────┤'), nl,
				write('├───────────┼─────────────────────────────┼───────────┤'), nl,
				write('│     🧸     ┼─────────────────────────────┼───────────┤'), nl,
				write('├───────────┼─────────────────────────────┼───────────┤'), nl,
				write('│───────────┼─────────────────────────────┼───────────┤'), nl,
				write('│───────────┼─────────────────────────────┤    🔫     │'), nl,
				write('├───────────┴─────────────────────────────┴───────────┤'), nl,
				write('│                                                     │'), nl,
				write('│                                                     │'), nl,
				write('│     ┌─────┐                                         │'), nl,
				write('│    ┌┘     └┐    < Guau esto tan tirado como de      │'), nl,
				write('│    │      o└┐     costumbre                         │'), nl,
				write('│    │       ┌┘                                       │'), nl,
				write('│    │      _│                                        │'), nl,
				write('│    └┐    ┌─┘                                        │'), nl,
				write('│    ┌┘   ┌┘                                          │'), nl,
				write('└────┴────┴───────────────────────────────────────────┘'), nl,
				write('He de buscar algo que me sirva contra el dragon...'), nl,
				write('Puede que haya algo en las estanterias.'), nl.

describir(taberna) :- 
				write('┌─────────┬─┬─────────────────────────────────────────┐'), nl,
				write('│         │ │                                         │'), nl,
				(esta_en(espada, taberna) ->write('│         │ │ 🕺              LA TABERNA       🗡️      │');
				                            write('│         │ │ 🕺              LA TABERNA              │')), nl,
				write('│     🕴️   │ │                DE KVOTHE                │'), nl,
				write('│         │ │                                         │'), nl,
				write('│         │ │    🕺                                   │'), nl,
				write('│         │ │ 🕺                                      │'), nl,
				write('│         │ │                                         │'), nl,
				write('│         │ │  🕺                                     │'), nl,
				write('│      ┌──┴─┘                                      🚶 │'), nl,
				write('│      │                                              │'), nl,
				write('│      │                                              │'), nl,
				write('│      │            e. para hablar con tu padre       │'), nl,
				write('│      │   PADRE                                      │'), nl,
				write('│      │    👨 🗝️  LLAVE                            sss   │'), nl,
				write('│      └──────────────────────────────────────────────┤'), nl,
				write('│                                                     │'), nl,
				write('└─────────────────────────────────────────────────────┘'), nl,
				write('La taberna tan sucia y llena como siempre. Ahi esta '), nl,
				write('mi padre, debo pedirle la llave.'), nl.