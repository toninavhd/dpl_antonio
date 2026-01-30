<?php
// Prueba DETALLADA de conexión
echo "<h2>🔍 Prueba de conexión PostgreSQL</h2>";

// Método 1: PDO directo
try {
    $pdo = new PDO('pgsql:host=127.0.0.1;port=5432;dbname=travelroad', 
                   'travelroad_user', 'dpl0000');
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    echo "✅ PDO: Conexión exitosa<br>";
    
    // Prueba consulta
    $stmt = $pdo->query("SELECT COUNT(*) as count FROM places");
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    echo "✅ PDO: Tabla 'places' tiene " . $result['count'] . " registros<br>";
    
    // Muestra datos
    $stmt = $pdo->query("SELECT name, visited FROM places ORDER BY name");
    echo "<h3>�� Datos en la tabla:</h3>";
    echo "<table border='1'><tr><th>Nombre</th><th>Visitado</th></tr>";
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        echo "<tr><td>{$row['name']}</td><td>" . ($row['visited'] ? '✅' : '⏳') . "</td></tr>";
    }
    echo "</table>";
    
} catch (PDOException $e) {
    echo "❌ PDO Error: " . $e->getMessage() . "<br>";
}

echo "<hr>";

// Método 2: Verificar configuración Laravel
echo "<h2>⚙️ Configuración Laravel</h2>";
$config = [
    'driver' => 'pgsql',
    'host' => '127.0.0.1',
    'port' => '5432',
    'database' => 'travelroad',
    'username' => 'travelroad_user',
    'password' => 'dpl0000',
];

echo "<pre>Configuración esperada: " . print_r($config, true) . "</pre>";

// Método 3: Probar conexión con pg_connect (más bajo nivel)
echo "<h2>�� Prueba pg_connect</h2>";
$conn_string = "host=127.0.0.1 port=5432 dbname=travelroad user=travelroad_user password=dpl0000";
$conn = pg_connect($conn_string);
if ($conn) {
    echo "✅ pg_connect: Conexión exitosa<br>";
    $result = pg_query($conn, "SELECT version()");
    $version = pg_fetch_result($result, 0);
    echo "✅ PostgreSQL Version: " . $version . "<br>";
    pg_close($conn);
} else {
    echo "❌ pg_connect: Falló<br>";
}
?>
