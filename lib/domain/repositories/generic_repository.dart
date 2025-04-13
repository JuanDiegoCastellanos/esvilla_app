abstract class GenericRepository<T, C, U> {
  Future<T> getById(String id);
  Future<List<T>> getAll();
  Future<T> add(C entity);
  Future<T> update(String id,U entity);
  Future<T> delete(String id);
}