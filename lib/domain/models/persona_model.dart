import '../entities/persona.dart';

class PersonaModel extends Persona {
  PersonaModel({
    super.idPersona,
    super.personaNombre,
    super.personaAp,
    super.personaCi,
    super.idOficina,
    super.idCargo,
    super.personaImagen,
  });

  factory PersonaModel.fromJson(Map<String, dynamic> json) {
    return PersonaModel(
      idPersona:     json['idPersona'],
      personaNombre: json['personaNombre'],
      personaAp:     json['personaAp'],
      personaCi:     json['personaCi'],
      idOficina:     json['idOficina'],
      idCargo:       json['idCargo'],
      personaImagen: json['personaImagen'],
    );
  }

  Map<String, dynamic> toJson() => {
    'personaNombre': personaNombre,
    'personaAp':     personaAp,
    'personaCi':     personaCi,
    'idOficina':     idOficina,
    'idCargo':       idCargo,
  };
}