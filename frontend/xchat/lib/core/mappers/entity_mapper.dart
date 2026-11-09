/// Converts between a data-layer model [M] and a domain entity [E].
/// Models never leave the data layer; entities never know about models.
abstract interface class EntityMapper<M, E> {
  E toEntity(M model);
  M toModel(E entity);
}
