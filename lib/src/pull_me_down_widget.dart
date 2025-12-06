import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import 'ui/painters/liquid_painter.dart';
import 'ui/indicators/liquid_spinner.dart';

/// A callback function that returns a Future.
/// Used for the refresh action.
typedef RefreshCallback = Future<void> Function();

/// A creative and easy-to-use pull-to-refresh widget.
class PullMeDown extends StatefulWidget {
  /// The widget that will be wrapped and made scrollable/refreshable.
  /// Usually a [ListView], [GridView], or [SingleChildScrollView].
  final Widget child;

  /// The async callback function that is triggered when the refresh is activated.
  /// This should return a [Future] that completes when the data is reloaded.
  final RefreshCallback onRefresh;

  /// The main background color of the liquid indicator.
  /// Defaults to [Theme.of(context).primaryColor] if not provided.
  final Color? refreshColor;

  /// Optional background color for the container behind the indicator.
  final Color? backgroundColor;

  /// The distance (in pixels) the user must pull down to trigger the refresh.
  /// Defaults to 100.0.
  final double refreshTriggerPullDistance;

  /// The height (in pixels) that the indicator rests at while refreshing.
  /// Defaults to 80.0.
  final double refreshIndicatorExtent;
  
  /// Custom color for the icon/spinner. 
  /// If null, it adapts automatically to contrast with [refreshColor].
  final Color? refreshIconColor;

  /// Optional custom widget to show when refreshing.
  /// Defaults to the custom [LiquidSpinner].
  final Widget? loadingIndicator;

  const PullMeDown({
    super.key,
    required this.child,
    required this.onRefresh,
    this.refreshColor,
    this.backgroundColor,
    this.refreshTriggerPullDistance = 100.0,
    this.refreshIndicatorExtent = 80.0,
    this.refreshIconColor,
    this.loadingIndicator,
  });

  @override
  State<PullMeDown> createState() => _PullMeDownState();
}

class _PullMeDownState extends State<PullMeDown> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  // ignore: unused_field
  late Animation<double> _animation;
  
  // The actual pull distance
  double _dragOffset = 0.0;
  
  // State management
  bool _isRefreshing = false;
  bool _isSuccess = false;
  
  // To track if we should reset
  // ignore: unused_field
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
       vsync: this,
       duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;
    
    HapticFeedback.mediumImpact();

    setState(() {
      _isRefreshing = true;
      _isSuccess = false;
    });
    
    // Animate to proper position for loading
    await _animationController.animateTo(
      1.0, 
      duration: const Duration(milliseconds: 400),
      curve: Curves.elasticOut,
    );

    try {
      await widget.onRefresh();
      if (mounted) {
        setState(() {
          _isSuccess = true;
        });
        HapticFeedback.lightImpact();
        await Future.delayed(const Duration(milliseconds: 600));
      }
    } finally {
      if (mounted) {
        // Smooth closer
        await _animationController.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOutBack);
        setState(() {
          _isRefreshing = false;
          _isSuccess = false;
          _dragOffset = 0.0;
        });
      }
    }
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (_isRefreshing) return false;

    if (notification is ScrollStartNotification) {
      if (notification.metrics.axis == Axis.vertical) {
         _isDragging = true;
      }
    }

    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.axis == Axis.vertical) {
        // Bouncing physics (iOS / BouncingScrollPhysics)
        if (notification.metrics.pixels < 0) {
           setState(() {
             _dragOffset = -notification.metrics.pixels;
           });
        }
        // Reset check
        else if (notification.metrics.pixels > 0) {
           if (_dragOffset > 0) {
              setState(() {
                _dragOffset = 0.0;
              });
           }
        }
      }
    } else if (notification is OverscrollNotification) {
       // Clamping physics (Android default)
       if (notification.metrics.axis == Axis.vertical) {
        if (notification.overscroll < 0) {
          setState(() {
             _dragOffset += -notification.overscroll; 
          });
        } 
      }
    } else if (notification is ScrollEndNotification) {
      _isDragging = false;
      if (_dragOffset >= widget.refreshTriggerPullDistance) {
        _handleRefresh();
      } else {
        if (_dragOffset > 0) {
          setState(() {
            _dragOffset = 0.0;
          });
        }
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = widget.refreshColor ?? theme.primaryColor;

    final contentOffset = _isRefreshing 
        ? widget.refreshIndicatorExtent 
        : (_dragOffset * 0.5); // Parallax factor

    return Stack(
      children: [
        // Content
        Transform.translate(
          offset: Offset(0, contentOffset),
          child: NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: widget.child,
          ),
        ),

        // Indicator
        if (_dragOffset > 1.0 || _isRefreshing)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: math.max(_dragOffset, widget.refreshIndicatorExtent + 50),
            child: IgnorePointer(
              child: CustomPaint(
                painter: LiquidPainter(
                  dragOffset: _isRefreshing ? widget.refreshIndicatorExtent : _dragOffset,
                  color: primaryColor,
                  isRefreshing: _isRefreshing,
                  isSuccess: _isSuccess,
                  maxExtent: widget.refreshTriggerPullDistance,
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: (_isRefreshing ? widget.refreshIndicatorExtent : _dragOffset) * 0.4
                    ),
                    child: _buildIcon(primaryColor),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildIcon(Color primaryColor) {
    if (_isSuccess) {
      // Just clean green state, no icon
      return const SizedBox(); 
    }
    
    // Determine the icon color (Manual override -> High Contrast calc -> White default)
    final iconColor = widget.refreshIconColor ?? 
       (primaryColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white);

    if (_isRefreshing) {
      // Allow custom widget or default to our LiquidSpinner
      return widget.loadingIndicator ?? LiquidSpinner(color: iconColor);
    }

    // Pulling state
    final percentage = (_dragOffset / widget.refreshTriggerPullDistance).clamp(0.0, 1.0);
    if (percentage < 0.15) return const SizedBox();

    return Opacity(
      opacity: percentage,
      child: Transform.rotate(
        angle: percentage * 2 * math.pi, // Spin effect
        child: Icon(
          Icons.arrow_downward_rounded, // Changed to arrow for clarity
          color: iconColor, 
          size: 20 + (percentage * 8)
        ),
      ),
    );
  }
}
