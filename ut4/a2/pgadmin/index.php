<?php
include 'config.php';

$dbconn = pg_connect($conn_string);

if (!$dbconn) {
    die("Error de conexión: " . pg_last_error());
}

// Consulta a la tabla places
$query = 'SELECT id, name, visited FROM places ORDER BY id ASC';
$result = pg_query($dbconn, $query);

if (!$result) {
    die("Error en la consulta: " . pg_last_error());
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>TravelRoad - Listado</title>
    <style>
        body { font-family: sans-serif; margin: 40px; background-color: #f4f4f9; }
        table { width: 100%; border-collapse: collapse; background: white; }
        th, td { border: 1px solid #ccc; padding: 12px; text-align: left; }
        th { background-color: #2c3e50; color: white; }
        tr:nth-child(even) { background-color: #f9f9f9; }
        .status { font-weight: bold; }
        .visited-t { color: green; }
        .visited-f { color: red; }
    </style>
</head>
<body>
    <h1>📍 TravelRoad: Mis Destinos!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!</h1>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Ciudad</th>
                <th>Visitado</th>
            </tr>
        </thead>
        <tbody>
            <?php while ($row = pg_fetch_assoc($result)): ?>
                <tr>
                    <td><?php echo $row['id']; ?></td>
                    <td><strong><?php echo htmlspecialchars($row['name']); ?></strong></td>
                    <td class="status <?php echo ($row['visited'] == 't') ? 'visited-t' : 'visited-f'; ?>">
                        <?php echo ($row['visited'] == 't') ? '✅ Sí' : '❌ No'; ?>
                    </td>
                </tr>
            <?php endwhile; ?>
        </tbody>
    </table>
</body>
</html>

<?php
pg_close($dbconn);
?>
