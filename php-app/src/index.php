<?php
$mysql_host = getenv('MYSQL_HOST'); 
$mysql_user = getenv('MYSQL_USER'); 
$mysql_pass = getenv('MYSQL_PASSWORD'); 
try {
    $pdo = new PDO("mysql:host=db; dbname=test", "user", "password");
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("MySQL Connection failed: " . $e->getMessage());
}


$mysql_query = "SELECT id, name, email FROM users"; 
try {
    $stmt = $pdo->query($mysql_query);
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        echo "MySQL User ID: " . $row['id'] . "<br>";
        echo "MySQL User Name: " . $row['name'] . "<br>";
        echo "MySQL User Email: " . $row['email'] . "<br><br>";
    }
} catch (PDOException $e) {
    echo "Error: " . $e->getMessage();
}

$pdo = null; 


$mongo_host = getenv('MONGO_HOST'); 

try {
    $mongo_conn = new MongoDB\Driver\Manager("mongodb://$mongo_host:27017");
    $mongo_query = new MongoDB\Driver\Query([]);
    $mongo_result = $mongo_conn->executeQuery('test.users', $mongo_query);

    foreach ($mongo_result as $document) {
        echo "MongoDB Name: " . $document->name . "<br>";
        echo "MongoDB Email: " . $document->email . "<br>";
        echo "MongoDB Usename: " . $document->username . "<br><br>";
    }
} catch (Exception $e) {
    echo "MongoDB Connection failed: " . $e->getMessage();
}
?>
