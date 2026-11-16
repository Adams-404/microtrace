import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../utils/platform_file.dart';

class MicroscopyImageView extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;

  const MicroscopyImageView({
    super.key,
    required this.path,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (ctx, err, stack) => _placeholder(),
      );
    }

    if (kIsWeb ||
        path.startsWith('http') ||
        path.startsWith('blob:') ||
        path.startsWith('data:')) {
      return Image.network(
        path,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (ctx, err, stack) => _placeholder(),
      );
    }

    // Check if local file exists on disk
    if (PlatformFileOps.fileExists(path)) {
      final bytes = PlatformFileOps.readFileBytes(path);
      if (bytes != null) {
        return Image.memory(
          bytes,
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (ctx, err, stack) => _placeholder(),
        );
      }
    }

    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.black,
      alignment: Alignment.center,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.biotech, color: AppColors.signal, size: 28),
          SizedBox(height: 6),
          Text(
            'OPTICAL FIELD',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
