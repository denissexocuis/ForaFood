package DAOs;

// c'est pour avoir une meilleure visualisation B)

// basicamente para tener todo organizado y no ser redundant

import org.bson.Document;
import org.bson.types.ObjectId;

public interface CRUD<T>
{
    void insertOne(T object);
    Document findOne(ObjectId object);
    void find(T object);
    void deleteOne(ObjectId object);
    void updateOne(T object);
}
