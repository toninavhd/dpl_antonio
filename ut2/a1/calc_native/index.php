<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calculadora PHP - Entorno Nativo</title>
    <link rel="stylesheet" href="calculadora.css">
</head>
<body>
    <div class="calculator-container">
        <h1>Calculadora en entorno nativo</h1>
        
        <div class="calculator-image">
            <img src="calculadora.png" alt="Calculadora" width="200">
        </div>
        
        <form method="POST" action="">
            <div class="form-group">
                <label for="num1">Número 1:</label>
                <input type="number" name="num1" id="num1" step="any" required 
                       placeholder="Ingresa el primer número">
            </div>

            <div class="form-group">
                <label for="num2">Número 2:</label>
                <input type="number" name="num2" id="num2" step="any" required 
                       placeholder="Ingresa el segundo número">
            </div>

            <div class="form-group">
                <label for="operation">Operación:</label>
                <select name="operation" id="operation" required>
                    <option value="add">Suma (+)</option>
                    <option value="subtract">Resta (-)</option>
                    <option value="multiply">Multiplicación (×)</option>
                    <option value="divide">División (÷)</option>
                </select>
            </div>

            <button type="submit" class="calculate-btn">Calcular</button>
        </form>

        <?php
        if ($_SERVER["REQUEST_METHOD"] == "POST") {
            $num1 = $_POST['num1'];
            $num2 = $_POST['num2'];
            $operation = $_POST['operation'];
            $result = null;
            $operation_symbol = "";
            
            switch ($operation) {
                case "add":
                    $result = $num1 + $num2;
                    $operation_symbol = "+";
                    break;
                case "subtract":
                    $result = $num1 - $num2;
                    $operation_symbol = "-";
                    break;
                case "multiply":
                    $result = $num1 * $num2;
                    $operation_symbol = "×";
                    break;
                case "divide":
                    if ($num2 != 0) {
                        $result = $num1 / $num2;
                        $operation_symbol = "÷";
                    } else {
                        $result = "Error";
                        $operation_symbol = "÷";
                    }
                    break;
                default:
                    $result = "Operación no válida.";
            }

            if ($result !== "Error") {
                echo "<div class='result'>";
                echo "<h2>Resultado:</h2>";
                echo "<p class='result-value'>" . htmlspecialchars($num1) . " $operation_symbol " . htmlspecialchars($num2) . " = " . htmlspecialchars($result) . "</p>";
                echo "</div>";
            } else {
                echo "<div class='result error'>";
                echo "<h2>Resultado:</h2>";
                echo "<p class='result-value'>" . htmlspecialchars($result) . ": División por cero no permitida.</p>";
                echo "</div>";
            }
        }
        ?>
    </div>
</body>
</html>
