<html>
  <head>
    <title>Travel List</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
      body {
        font-family: Arial, sans-serif;
        max-width: 800px;
        margin: 0 auto;
        padding: 20px;
        background-color: #f5f5f5;
      }
      h1 {
        color: #e7444e;
        text-align: center;
      }
      h2 {
        color: #333;
        border-bottom: 2px solid #e7444e;
        padding-bottom: 10px;
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
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      }
      .powered-by {
        text-align: center;
        margin-top: 40px;
        padding-top: 20px;
        border-top: 1px solid #ddd;
        color: #666;
      }
      .powered-by a {
        color: #e7444e;
        text-decoration: none;
      }
    </style>
  </head>

  <body>
    <h1>✈️ My Travel Bucket List</h1>
    
    <h2>Places I'd Like to Visit</h2>
    <ul>
      <?php $__empty_1 = true; $__currentLoopData = $wished; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $place): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
      <li>📍 <?php echo e($place->name); ?></li>
      <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
      <li>No places in your wishlist yet!</li>
      <?php endif; ?>
    </ul>

    <h2>Places I've Already Been To</h2>
    <ul>
      <?php $__empty_1 = true; $__currentLoopData = $visited; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $place): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
      <li>✅ <?php echo e($place->name); ?></li>
      <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
      <li>No places visited yet!</li>
      <?php endif; ?>
    </ul>

    <div class="powered-by">
      <p>Powered by <strong><a href="https://laravel.com" target="_blank">Laravel</a></strong></p>
      <p style="margin-top: 10px; font-size: 0.9rem;">TravelRoad - Laravel Application (PHP 8.4)</p>
    </div>
  </body>
</html>

<?php /**PATH /home/toni/Documentos/dpl_antonio/ut4/a3/travelroad_laravel/resources/views/travelroad.blade.php ENDPATH**/ ?>