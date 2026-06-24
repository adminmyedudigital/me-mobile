import 'package:flutter/material.dart';

@immutable
final class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.primaryOn,
    required this.ink,
    required this.body,
    required this.charcoal,
    required this.mute,
    required this.ash,
    required this.stone,
    required this.onLight,
    required this.onLightMute,
    required this.canvas,
    required this.surfaceCard,
    required this.surfaceElevated,
    required this.surfaceDeep,
    required this.hairline,
    required this.hairlineStrong,
    required this.dividerSoft,
    required this.accentOrange,
    required this.accentOrangeGlow,
    required this.accentYellow,
    required this.accentBlue,
    required this.accentBlueGlow,
    required this.accentGreen,
    required this.accentGreenGlow,
    required this.accentRed,
    required this.accentRedGlow,
    required this.link,
    required this.surfaceLight,
  });

  factory AppColors.brand() => const AppColors(
    primary: Color(0xFFFCFDFF),
    primaryOn: Color(0xFF000000),
    ink: Color(0xFFFCFDFF),
    body: Color.fromRGBO(252, 253, 255, 0.86),
    charcoal: Color.fromRGBO(252, 253, 255, 0.7),
    mute: Color(0xFFA1A4A5),
    ash: Color(0xFF888E90),
    stone: Color(0xFF464A4D),
    onLight: Color(0xFF000000),
    onLightMute: Color.fromRGBO(0, 0, 51, 0.7),
    canvas: Color(0xFF000000),
    surfaceCard: Color(0xFF0A0A0C),
    surfaceElevated: Color(0xFF101012),
    surfaceDeep: Color(0xFF06060A),
    hairline: Color.fromRGBO(255, 255, 255, 0.06),
    hairlineStrong: Color.fromRGBO(255, 255, 255, 0.14),
    dividerSoft: Color.fromRGBO(255, 255, 255, 0.04),
    accentOrange: Color(0xFFFF801F),
    accentOrangeGlow: Color.fromRGBO(255, 89, 0, 0.22),
    accentYellow: Color(0xFFFFC53D),
    accentBlue: Color(0xFF3B9EFF),
    accentBlueGlow: Color.fromRGBO(0, 117, 255, 0.34),
    accentGreen: Color(0xFF11FF99),
    accentGreenGlow: Color.fromRGBO(34, 255, 153, 0.18),
    accentRed: Color(0xFFFF2047),
    accentRedGlow: Color.fromRGBO(255, 32, 71, 0.34),
    link: Color(0xFF3B9EFF),
    surfaceLight: Color(0xFFF1F7FE),
  );

  final Color primary;
  final Color primaryOn;
  final Color ink;
  final Color body;
  final Color charcoal;
  final Color mute;
  final Color ash;
  final Color stone;
  final Color onLight;
  final Color onLightMute;
  final Color canvas;
  final Color surfaceCard;
  final Color surfaceElevated;
  final Color surfaceDeep;
  final Color hairline;
  final Color hairlineStrong;
  final Color dividerSoft;
  final Color accentOrange;
  final Color accentOrangeGlow;
  final Color accentYellow;
  final Color accentBlue;
  final Color accentBlueGlow;
  final Color accentGreen;
  final Color accentGreenGlow;
  final Color accentRed;
  final Color accentRedGlow;
  final Color link;
  final Color surfaceLight;

  @override
  AppColors copyWith({
    Color? primary,
    Color? primaryOn,
    Color? ink,
    Color? body,
    Color? charcoal,
    Color? mute,
    Color? ash,
    Color? stone,
    Color? onLight,
    Color? onLightMute,
    Color? canvas,
    Color? surfaceCard,
    Color? surfaceElevated,
    Color? surfaceDeep,
    Color? hairline,
    Color? hairlineStrong,
    Color? dividerSoft,
    Color? accentOrange,
    Color? accentOrangeGlow,
    Color? accentYellow,
    Color? accentBlue,
    Color? accentBlueGlow,
    Color? accentGreen,
    Color? accentGreenGlow,
    Color? accentRed,
    Color? accentRedGlow,
    Color? link,
    Color? surfaceLight,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      primaryOn: primaryOn ?? this.primaryOn,
      ink: ink ?? this.ink,
      body: body ?? this.body,
      charcoal: charcoal ?? this.charcoal,
      mute: mute ?? this.mute,
      ash: ash ?? this.ash,
      stone: stone ?? this.stone,
      onLight: onLight ?? this.onLight,
      onLightMute: onLightMute ?? this.onLightMute,
      canvas: canvas ?? this.canvas,
      surfaceCard: surfaceCard ?? this.surfaceCard,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      surfaceDeep: surfaceDeep ?? this.surfaceDeep,
      hairline: hairline ?? this.hairline,
      hairlineStrong: hairlineStrong ?? this.hairlineStrong,
      dividerSoft: dividerSoft ?? this.dividerSoft,
      accentOrange: accentOrange ?? this.accentOrange,
      accentOrangeGlow: accentOrangeGlow ?? this.accentOrangeGlow,
      accentYellow: accentYellow ?? this.accentYellow,
      accentBlue: accentBlue ?? this.accentBlue,
      accentBlueGlow: accentBlueGlow ?? this.accentBlueGlow,
      accentGreen: accentGreen ?? this.accentGreen,
      accentGreenGlow: accentGreenGlow ?? this.accentGreenGlow,
      accentRed: accentRed ?? this.accentRed,
      accentRedGlow: accentRedGlow ?? this.accentRedGlow,
      link: link ?? this.link,
      surfaceLight: surfaceLight ?? this.surfaceLight,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }

    Color lerpColor(Color a, Color b) => Color.lerp(a, b, t) ?? a;

    return AppColors(
      primary: lerpColor(primary, other.primary),
      primaryOn: lerpColor(primaryOn, other.primaryOn),
      ink: lerpColor(ink, other.ink),
      body: lerpColor(body, other.body),
      charcoal: lerpColor(charcoal, other.charcoal),
      mute: lerpColor(mute, other.mute),
      ash: lerpColor(ash, other.ash),
      stone: lerpColor(stone, other.stone),
      onLight: lerpColor(onLight, other.onLight),
      onLightMute: lerpColor(onLightMute, other.onLightMute),
      canvas: lerpColor(canvas, other.canvas),
      surfaceCard: lerpColor(surfaceCard, other.surfaceCard),
      surfaceElevated: lerpColor(surfaceElevated, other.surfaceElevated),
      surfaceDeep: lerpColor(surfaceDeep, other.surfaceDeep),
      hairline: lerpColor(hairline, other.hairline),
      hairlineStrong: lerpColor(hairlineStrong, other.hairlineStrong),
      dividerSoft: lerpColor(dividerSoft, other.dividerSoft),
      accentOrange: lerpColor(accentOrange, other.accentOrange),
      accentOrangeGlow: lerpColor(accentOrangeGlow, other.accentOrangeGlow),
      accentYellow: lerpColor(accentYellow, other.accentYellow),
      accentBlue: lerpColor(accentBlue, other.accentBlue),
      accentBlueGlow: lerpColor(accentBlueGlow, other.accentBlueGlow),
      accentGreen: lerpColor(accentGreen, other.accentGreen),
      accentGreenGlow: lerpColor(accentGreenGlow, other.accentGreenGlow),
      accentRed: lerpColor(accentRed, other.accentRed),
      accentRedGlow: lerpColor(accentRedGlow, other.accentRedGlow),
      link: lerpColor(link, other.link),
      surfaceLight: lerpColor(surfaceLight, other.surfaceLight),
    );
  }
}
