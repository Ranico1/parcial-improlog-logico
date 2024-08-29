% integrante(Grupo, Persona, InstrumentoQueToca)

integrante(sophieTrio, sophie, violin).
integrante(sophieTrio, santi, guitarra).
integrante(vientosDelEste, lisa, saxo).
integrante(vientosDelEste, santi, voz).
integrante(vientosDelEste, santi, guitarra).
integrante(jazzmin, santi, bateria).

% nivelQueTiene(Persona, Instrumento, Nivel)

nivelQueTiene(sophie, violin, 5).
nivelQueTiene(santi, guitarra, 2).
nivelQueTiene(santi, voz, 3).
nivelQueTiene(santi, bateria, 4).
nivelQueTiene(lisa, saxo, 4).
nivelQueTiene(lore, violin, 4).
nivelQueTiene(luis, trompeta, 1).
nivelQueTiene(luis, contrabajo, 4).


% instrumento(Instrumento, RolQueCumple())
instrumento(violin, melodico(cuerdas)).
instrumento(guitarra, armonico).
instrumento(bateria, ritmico).
instrumento(saxo, melodico(viento)).
instrumento(trompeta, melodico(viento)).
instrumento(contrabajo, armonico).
instrumento(bajo, armonico).
instrumento(piano, armonico).
instrumento(pandereta, ritmico).
instrumento(voz, melodico(vocal)).


% Punto 1

tieneBuenaBase(Grupo) :-
    integrante(Grupo,Persona,Instrumento),
    instrumento(Instrumento, ritmico),
    integrante(Grupo, OtraPersona, OtroInstrumento),
    instrumento(OtroInstrumento, armonico),
    Persona \= OtraPersona. 


% Punto 2

seDestaca(Persona, Grupo) :- 
    integrante(Grupo, Persona,_), 
    forall((integrante(Grupo, OtraPersona,_), Persona \= OtraPersona), muchaDiferenciaDeNivel(Persona, OtraPersona)).

muchaDiferenciaDeNivel(Persona, OtraPersona) :- 
    nivelQueTiene(Persona, _, Nivel),
    nivelQueTiene(OtraPersona, _, OtroNivel),
    Diferencia is Nivel - OtroNivel,
    Diferencia >= 2.

% Punto 3
grupo(vientosDelEste, tipo(bigband)).
grupo(sophieTrio, tipo(formacionParticular, [contrabajo, guitarra, violin])).
grupo(jazzmin, tipo(formacionParticular, [bateria, bajo, trompeta, piano, guitarra])).
grupo(estudio1, tipo(ensamble, 3)).

% Puntp 4

hayCupo(Instrumento, Grupo) :-
    grupo(Grupo, tipo(bigband)),
    instrumento(Instrumento, melodico(viento)).

hayCupo(Instrumento, Grupo) :-
    grupo(Grupo, TipoDeGrupo),
    nadieToca(Instrumento, Grupo),
    sirveParaElGrupo(Instrumento, TipoDeGrupo).

nadieToca(Instrumento, Grupo) :-
    instrumento(Instrumento, _),
    not(integrante(Grupo, _, Instrumento)).

sirveParaElGrupo(Instrumento, tipo(formacionParticular, Instrumentos)) :-
    member(Instrumento, Instrumentos).

sirveParaElGrupo(bateria, tipo(bigband)).
sirveParaElGrupo(bajo, tipo(bigband)).
sirveParaElGrupo(piano, tipo(bigband)).
sirveParaElGrupo(_, tipo(ensamble, _)).



% Punto 5

puedeIncorporarse(Persona, Grupo, Instrumento) :-
    nivelQueTiene(Persona, Instrumento, Nivel),
    not(integrante(Grupo,Persona,_)),
    hayCupo(Instrumento, Grupo),
    altoNivel(Nivel, Grupo). 


altoNivel(Nivel, Grupo) :-
    grupo(Grupo, Tipo),
    altoNivelSegunTipo(NivelEsperado, Tipo),
    Nivel >= NivelEsperado. 


altoNivelSegunTipo(1, tipo(bigband)).

altoNivelSegunTipo(NivelEsperado, tipo(formacionParticular, Instrumentos)) :-
    length(Instrumentos, CantInstrumentos),
    NivelEsperado is 7 - CantInstrumentos.

% Punto 6

seQuedoEnBanda(Persona) :-
    nivelQueTiene(Persona,Instrumento,_),
    not(integrante(_,Persona,_)),
    not(puedeIncorporarse(Persona,_,Instrumento)). 

% Punto 7

puedeTocar(Grupo) :- 
    grupo(Grupo, Tipo)
    cumpleNecesidades(Grupo,Tipo).

cumpleNecesidades(Grupo,tipo(bigband)) :-
     tieneBuenaBase(Grupo),
     findall(Personas, tipoDeInstrumento(Grupo, Persona), ListaViento),
     length(ListaViento, CantViento),
     CantViento >= 5. 

cumpleNecesidades(Grupo, tipo(formacionParticular, Instrumentos)) :- 
    forall(member(Instrumento, Instrumentos), integrante(Grupo, Persona, Instrumento)).

tipoDeInstrumento(Grupo, Persona) :-
    integrante(Grupo, Persona, Instrumento),
    instrumento(Instrumento, melodico(viento)). 
     
     







