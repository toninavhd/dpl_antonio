<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Travel List</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        h1 {
            color: #2c3e50;
            text-align: center;
            border-bottom: 3px solid #e74c3c;
            padding-bottom: 10px;
        }
        h2 {
            color: #34495e;
            margin-top: 30px;
        }
        ul {
            list-style-type: none;
            padding: 0;
        }
        li {
            background-color: white;
            margin: 10px 0;
            padding: 15px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            transition: transform 0.2s;
        }
        li:hover {
            transform: translateX(5px);
        }
        .wished li {
            border-left: 4px solid #e74c3c;
        }
        .visited li {
            border-left: 4px solid #27ae60;
        }
        .footer {
            margin-top: 50px;
            text-align: center;
            color: #7f8c8d;
            font-size: 0.9em;
            padding: 20px;
            border-top: 1px solid #ddd;
        }
        .powered {
            color: #e74c3c;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <h1>My Travel Bucket List</h1>
    
    <h2>Places I'd Like to Visit</h2>
    <ul class="wished">
        @foreach ($wished as $place)
        <li>{{ $place->name }}</li>
        @endforeach
    </ul>

    <h2>Places I've Already Been To</h2>
    <ul class="visited">
        @foreach ($visited as $place)
        <li>{{ $place->name }}</li>
        @endforeach
    </ul>

    <div class="footer">
        <p>Powered by <span class="powered">Laravel</span></p>
    </div>
</body>
</html>
