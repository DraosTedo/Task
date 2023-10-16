db = db.getSiblingDB('test')
db.createCollection("users");
db.users.insert({"name":"Test", "email":"test@test.com", "username":"test"})