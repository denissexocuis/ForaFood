package DAOs;

// c'est pour avoir une meilleure visualisation B)

// basicamente para tener todo organizado y no ser redundant

public interface CRUD<T>
{
    void insertOne(T object);
    void findOne(T object);
    void find(T object);
    void deleteOne(T object);
    void updateOne(T object);
}
