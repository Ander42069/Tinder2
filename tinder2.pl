% Base de datos de personas con gustos
persona(juan, hombre, [futbol, musica]).
persona(pedro, hombre, [lectura, cine, viajes]).
persona(carlos, hombre, [gimnasio, musica]).
persona(alejandro, hombre, [programacion, deportes]).
persona(luis, hombre, [futbol, jardineria]).
persona(miguel, hombre, [cine, musica]).
persona(pablo, hombre, [viajes, cocina]).
persona(fernando, hombre, [musica, pintura]).
persona(javier, hombre, [teatro, ciclismo]).
persona(victor, hombre, [ajedrez, programacion]).
persona(maria, mujer, [moda, yoga, musica]).
persona(ana, mujer, [lectura, viajes, cine]).
persona(luisa, mujer, [gimnasio, baile]).
persona(sofia, mujer, [fotografia, musica]).
persona(laura, mujer, [senderismo, musica]).
persona(carmen, mujer, [teatro, cocina]).
persona(elena, mujer, [pintura, musica]).
persona(isabel, mujer, [cine, literatura]).
persona(clara, mujer, [jardineria, musica]).
persona(rosa, mujer, [viajes, musica]).

% Funciones de Comparacion de Caracteres y Similitud
son_similares(Cadena1, Cadena2) :-
    atom_chars(Cadena1, Chars1),
    atom_chars(Cadena2, Chars2),
    length(Chars1, Longitud1),
    length(Chars2, Longitud2),
    LongitudMayor is max(Longitud1, Longitud2),
    comparar_caracteres(Chars1, Chars2, LongitudMayor, 0, Coincidentes),
    LongitudCoincidentes is length(Coincidentes),
    porcentaje_similitud(LongitudCoincidentes, Longitud1, Longitud2, Porcentaje),
    Porcentaje >= 70.

comparar_caracteres([], _, _, Coincidentes, Coincidentes).
comparar_caracteres(_, [], _, Coincidentes, Coincidentes).
comparar_caracteres([Char1 | Resto1], Lista2, Longitud, CoincidentesAcc, Coincidentes) :-
    member(Char1, Lista2),
    son_similares_restantes(Lista2, Char1, Longitud, CoincidentesAcc, CoincidentesRestantes),
    comparar_caracteres(Resto1, CoincidentesRestantes, Longitud, CoincidentesAcc, Coincidentes).
comparar_caracteres([_ | Resto1], Lista2, Longitud, CoincidentesAcc, Coincidentes) :-
    comparar_caracteres(Resto1, Lista2, Longitud, CoincidentesAcc, Coincidentes).

son_similares_restantes([], _, _, Coincidentes, Coincidentes).
son_similares_restantes([Char | Resto], CharBase, Longitud, CoincidentesAcc, Coincidentes) :-
    son_similares(Char, CharBase),
    append(CoincidentesAcc, [Char], CoincidentesRestantes),
    son_similares_restantes(Resto, CharBase, Longitud, CoincidentesRestantes, Coincidentes).
son_similares_restantes([_ | Resto], CharBase, Longitud, CoincidentesAcc, Coincidentes) :-
    son_similares_restantes(Resto, CharBase, Longitud, CoincidentesAcc, Coincidentes).

% Funciones de Calculo de Compatibilidad
calcular_compatibilidad_gustos(GustosUsuario, GustosPersona, Compatibilidad) :-
    intersection(GustosUsuario, GustosPersona, GustosComunes),
    length(GustosComunes, LongitudComunes),
    length(GustosUsuario, LongitudUsuario),
    Compatibilidad is (LongitudComunes * 100) / LongitudUsuario.

calcular_compatibilidad(GustosUsuario, GustosPersona, Porcentaje) :-
    length(GustosUsuario, LongitudUsuario),
    length(GustosPersona, LongitudPersona),
    intersection(GustosUsuario, GustosPersona, GustosComunes),
    length(GustosComunes, LongitudComunes),
    porcentaje_similitud(LongitudComunes, LongitudUsuario, LongitudPersona, Porcentaje).

porcentaje_similitud(Comunes, TotalUsuario, TotalPersona, Porcentaje) :-
    MaximoTotal is max(TotalUsuario, TotalPersona),
    Porcentaje is (Comunes * 100) / MaximoTotal.

% Funciones de Impresion de Personas y Listas
imprimir_personas_con_gustos_y_compatibilidad(SexoUsuario, GustosUsuario) :-
    write('Personas de '), write(SexoUsuario), write(' con sus gustos y compatibilidad: '), nl,
    findall((Nombre, Gustos, Compatibilidad), 
            (persona(Nombre, Sexo, Gustos),
             Sexo \= SexoUsuario,
             calcular_compatibilidad_gustos(GustosUsuario, Gustos, Compatibilidad)),
            Personas),
    imprimir_personas_con_gustos_compatibilidad_lista(Personas, GustosUsuario).
    
imprimir_personas_con_gustos_compatibilidad_lista([], _).
imprimir_personas_con_gustos_compatibilidad_lista([(Nombre, Gustos, Compatibilidad) | Resto], GustosUsuario) :-
    write('- '), write(Nombre),
    write(' | Gustos: '), write(Gustos),
    write(' | Compatibilidad: '), write(Compatibilidad), write('%'), nl,
    imprimir_personas_con_gustos_compatibilidad_lista(Resto, GustosUsuario).

% Predicado para emparejar dos personas
emparejar(NombreUsuario, Pareja) :-
    write('¡Hiciste match con '), write(Pareja), write('!'), nl,
    write('¡Felicidades '), write(NombreUsuario), write(' y '), write(Pareja), write('!').

% Funcion Principal
emparejar_personas :-
    write('Hola, ¿como te llamas? '),
    read(NombreUsuario),
    nl,
    write('¿Eres hombre o mujer? '),
    read(GeneroUsuario),
    nl,
    write('¿Cuales son tus gustos? (Escribe entre corchetes y 
    separa los gustos con comas) '),
    read(GustosUsuario),
    nl,
    write('¡Hola '), write(NombreUsuario),
    write(', aqui tienes personas del sexo opuesto con sus gustos y compatibilidad:'), 
    nl,
    imprimir_personas_con_gustos_y_compatibilidad(GeneroUsuario, GustosUsuario),
    nl,
    write('¿Con quien quieres emparejarte? '),
    read(Pareja),
    nl,
    emparejar(NombreUsuario, Pareja).

% Consulta principal
% Para probar la compatibilidad
% ?- emparejar_personas.