// njs script for image processing with ImageMagick
// This script handles image transformations using ImageMagick commands

import { resolve } from 'path';
import { writeFileSync, unlinkSync, existsSync } from 'fs';
import { spawnSync } from 'child_process';

export default function imageProcessor(r) {
    const url = new URL(r.uri, `https://${r.headersIn.Host || 'localhost'}`);
    const pathname = url.pathname;
    
    // Extract image filename
    const imageMatch = pathname.match(/\/img\/(\w+\.\w+)$/);
    if (!imageMatch) {
        r.return(404, 'Image not found');
        return;
    }
    
    const imageName = imageMatch[1];
    const originalPath = `/var/www/html/img/${imageName}`;
    
    // Check if original image exists
    if (!existsSync(originalPath)) {
        r.return(404, 'Image not found');
        return;
    }
    
    // Get parameters from query string
    const params = new URLSearchParams(url.search);
    const size = params.get('size') || params.get('small') || '300';
    const border = params.get('border') || params.get('extborder') || '0';
    const borderColor = params.get('bordercolor') || params.get('extbordercolor') || '#000000';
    const blur = params.get('blur') || params.get('gaussianblur') || '0';
    const focus = params.get('focus') || params.get('radialblur') || '0';
    
    // Parse blur parameters
    let blurRadius = '0';
    let blurSigma = '0';
    if (blur && blur.includes('x')) {
        [blurRadius, blurSigma] = blur.split('x');
    }
    
    let focusRadius = '0';
    let focusSigma = '0';
    if (focus && focus.includes('x')) {
        [focusRadius, focusSigma] = focus.split('x');
    }
    
    const tempOutput = `/tmp/processed_${Date.now()}.jpg`;
    
    // Build ImageMagick command
    let cmd = ['convert', originalPath];
    
    // Resize to square
    if (size && size !== 'original') {
        cmd.push('-resize', `${size}x${size}^`);
        cmd.push('-gravity', 'center');
        cmd.push('-extent', `${size}x${size}`);
    }
    
    // Add border
    if (border && parseInt(border) > 0) {
        cmd.push('-border', border);
        cmd.push('-bordercolor', borderColor);
    }
    
    // Add blur
    if (blur && (blurRadius !== '0' || blurSigma !== '0')) {
        cmd.push('-blur', `${blurRadius}x${blurSigma}`);
    }
    
    // Add focus (sharpen)
    if (focus && (focusRadius !== '0' || focusSigma !== '0')) {
        cmd.push('-sharpen', `${focusRadius}x${focusSigma}`);
    }
    
    // Output
    cmd.push(tempOutput);
    
    // Execute ImageMagick
    const result = spawnSync('convert', cmd);
    
    if (result.error || !existsSync(tempOutput)) {
        // Fallback: return original image
        r.return(200, 'Error processing image, returning original');
        return;
    }
    
    // Read processed image
    const fs = require('fs');
    const imageBuffer = fs.readFileSync(tempOutput);
    
    // Clean up
    try { unlinkSync(tempOutput); } catch(e) {}
    
    // Set content type and return image
    r.status = 200;
    r.headersOut['Content-Type'] = 'image/jpeg';
    r.headersOut['Content-Length'] = imageBuffer.length.toString();
    r.sendBuffer(imageBuffer);
}

