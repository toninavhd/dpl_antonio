<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TravelRoad - Laravel</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #ff6b6b 0%, #feca57 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .container {
            text-align: center;
            background: white;
            padding: 50px;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.2);
            max-width: 600px;
        }
        h1 {
            color: #e7444e;
            margin-bottom: 20px;
            font-size: 2.5rem;
        }
        .subtitle {
            color: #666;
            margin-bottom: 30px;
            font-size: 1.2rem;
        }
        .powered-by {
            margin-top: 40px;
            padding-top: 20px;
            border-top: 2px solid #f0f0f0;
            color: #999;
            font-size: 0.9rem;
        }
        .powered-by strong {
            color: #e7444e;
        }
        .features {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin: 30px 0;
            flex-wrap: wrap;
        }
        .feature {
            background: #f8f9fa;
            padding: 15px 25px;
            border-radius: 10px;
            color: #555;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>✈️ TravelRoad</h1>
        <p class="subtitle">Tu aplicación de viajes desarrollada con Laravel</p>
        
        <div class="features">
            <div class="feature">🚀 Laravel 12</div>
            <div class="feature">🐘 PHP 8.4</div>
            <div class="feature">🗄️ PostgreSQL</div>
        </div>
        
        <p style="color: #888;">La aplicación está configurada correctamente.</p>
        <p style="color: #888; margin-top: 10px;">Accede a <code>/travelroad</code> para ver la lista de lugares.</p>
        
        <div class="powered-by">
            <p>Powered by <strong>Laravel-00000</strong></p>
        </div>
    </div>
</body>
</html>

