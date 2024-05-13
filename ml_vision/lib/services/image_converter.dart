import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:image/image.dart' as imglib;
import 'package:camera/camera.dart';
import 'dart:typed_data';

imglib.Image convertToImage(CameraImage image) {
  try {
    print('image.format.group=>${image.format.group}');
    if (image.format.group == ImageFormatGroup.nv21) {
      return _convertNV21(image);
    } else {
      if (image.format.group == ImageFormatGroup.bgra8888) {
        return _convertBGRA8888(image);
      } else if (image.format.group == ImageFormatGroup.yuv420) {
        _convertYUV420(image);
      }
    }
    throw Exception('Image format not supported');
  } catch (e) {
    print("ERROR:" + e.toString());
  }
  throw Exception('Image format not supported');
}

imglib.Image _convertBGRA8888(CameraImage image) {
  return imglib.Image.fromBytes(
    image.width,
    image.height,
    image.planes[0].bytes,
    format: imglib.Format.bgra,
  );
}

imglib.Image _convertYUV420(CameraImage image) {
  int width = image.width;
  int height = image.height;
  var img = imglib.Image(width, height);
  const int hexFF = 0xFF000000;
  final int uvyButtonStride = image.planes[1].bytesPerRow;
  final int? uvPixelStride = image.planes[1].bytesPerPixel;
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      final int uvIndex =
          uvPixelStride! * (x / 2).floor() + uvyButtonStride * (y / 2).floor();
      final int index = y * width + x;
      final yp = image.planes[0].bytes[index];
      final up = image.planes[1].bytes[uvIndex];
      final vp = image.planes[2].bytes[uvIndex];
      int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
      int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
          .round()
          .clamp(0, 255);
      int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
      img.data[index] = hexFF | (b << 16) | (g << 8) | r;
    }
  }

  return img;
}

imglib.Image _convertNV21(CameraImage image) {
  final width = image.width.toInt();
  final height = image.height.toInt();
  Uint8List yuv420sp = image.planes[0].bytes;

  // Initial conversion from NV21 to RGB
  final outImg = imglib.Image(height, width); // Note the swapped dimensions
  final int frameSize = width * height;

  for (int j = 0, yp = 0; j < height; j++) {
    int uvp = frameSize + (j >> 1) * width, u = 0, v = 0;
    for (int i = 0; i < width; i++, yp++) {
      int y = (0xff & yuv420sp[yp]) - 16;
      if (y < 0) y = 0;
      if ((i & 1) == 0) {
        v = (0xff & yuv420sp[uvp++]) - 128;
        u = (0xff & yuv420sp[uvp++]) - 128;
      }
      int y1192 = 1192 * y;
      int r = (y1192 + 1634 * v);
      int g = (y1192 - 833 * v - 400 * u);
      int b = (y1192 + 2066 * u);

      if (r < 0) {
        r = 0;
      } else if (r > 262143) r = 262143;
      if (g < 0) {
        g = 0;
      } else if (g > 262143) g = 262143;
      if (b < 0) {
        b = 0;
      } else if (b > 262143) b = 262143;

      outImg.setPixelRgba(j, width - i - 1, ((r << 6) & 0xff0000) >> 16,
          ((g >> 2) & 0xff00) >> 8, (b >> 10) & 0xff);
    }
  }
  return outImg;
  // Rotate the image by 90 degrees (or 270 degrees if needed)
  // return imglib.copyRotate(outImg, -90); // Use -90 for a 270 degrees rotation
}

imglib.Image _convertNV21ToRGB(CameraImage image) {
  int width = image.width;
  int height = image.height;
  // Convert NV21 to YUV420
  imglib.Image yuvImage = imglib.Image(width, height);
  _copyNV21toYUV420(yuvImage, image.planes[0].bytes, width, height);

  // Convert YUV420 to RGB
  imglib.Image rgbImage = imglib.Image(width, height);
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int yp = yuvImage.getPixel(x, y);
      int r = (yp & 0xff);
      int g = (yp >> 8) & 0xff;
      int b = (yp >> 16) & 0xff;
      rgbImage.setPixel(x, y, imglib.getColor(r, g, b));
    }
  }

  return rgbImage;
}

void _copyNV21toYUV420(
    imglib.Image yuvImage, Uint8List nv21Data, int width, int height) {
  int uvHeight = height ~/ 2;
  int uvWidth = width ~/ 2;
  int uvIndex = width * height;
  // Copier les données Y (luminance)
  for (int i = 0; i < height; i++) {
    for (int j = 0; j < width; j++) {
      int index = i * width + j;
      yuvImage.data[index] = nv21Data[index];
    }
  }

  // Copier les données UV (chrominance)
  for (int i = 0; i < uvHeight; i++) {
    for (int j = 0; j < uvWidth; j++) {
      int yIndex = uvIndex + i * width + j * 2; // Index Y correspondant
      int uvOffset = width * height + i * uvWidth + j;
      if (yIndex < nv21Data.length && uvOffset < yuvImage.length) {
        yuvImage.data[uvOffset] = nv21Data[yIndex]; // U
        yuvImage.data[uvOffset + 1] = nv21Data[yIndex + 1]; // V
      }
    }
  }
}
