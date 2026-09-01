import 'package:flutter/widgets.dart';
import 'package:islami_hayat/features/share/domain/runtime_religious_content_t0243.dart';
import 'package:islami_hayat/features/share/domain/share_canvas_layout_t0242.dart';
import 'package:islami_hayat/features/share/presentation/share_layout_renderer_t0242.dart';

class RuntimeReligiousShareCardT0243 extends StatelessWidget {
  const RuntimeReligiousShareCardT0243({
    required this.format,
    required this.background,
    required this.content,
    super.key,
  });

  final ShareCanvasFormatT0242 format;
  final Widget background;
  final RuntimeReligiousShareContentT0243 content;

  @override
  Widget build(BuildContext context) {
    return ShareLayoutRendererT0242(
      format: format,
      background: background,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            content.text,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            content.sourceLabel,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
