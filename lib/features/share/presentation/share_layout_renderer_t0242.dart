import 'package:flutter/widgets.dart';
import 'package:islami_hayat/features/share/domain/share_canvas_layout_t0242.dart';
import 'package:islami_hayat/features/share/domain/share_readability_t0247.dart';

class ShareLayoutRendererT0242 extends StatelessWidget {
  const ShareLayoutRendererT0242({
    required this.format,
    required this.background,
    required this.content,
    this.readabilityDecision,
    this.repaintBoundaryKey,
    super.key,
  });

  final ShareCanvasFormatT0242 format;
  final Widget background;
  final Widget content;
  final ShareReadabilityDecisionT0247? readabilityDecision;
  final Key? repaintBoundaryKey;

  @override
  Widget build(BuildContext context) {
    final layout = ShareCanvasLayoutT0242.forFormat(format)..validate();
    readabilityDecision?.requireExportable();

    final readableContent = readabilityDecision == null
        ? content
        : DefaultTextStyle.merge(
            style: TextStyle(color: readabilityDecision!.foregroundColor),
            child: content,
          );

    return RepaintBoundary(
      key: repaintBoundaryKey,
      child: AspectRatio(
        aspectRatio: layout.aspectRatio,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            final horizontal = width * layout.safeHorizontalFraction;
            final top = height * layout.safeTopFraction;
            final bottom = height * layout.safeBottomFraction;

            return Stack(
              fit: StackFit.expand,
              children: [
                background,
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    horizontal,
                    top,
                    horizontal,
                    bottom,
                  ),
                  child: readableContent,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
