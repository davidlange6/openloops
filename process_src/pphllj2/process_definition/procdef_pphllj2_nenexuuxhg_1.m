
FeynArtsProcess = {F[1, {1}], -F[1, {1}]} -> {-F[3, {1}], F[3, {1}], S[1], V[5]};

SortExternal = True;

OpenLoopsModel = "SM_yuksel";

CreateTopologiesOptions = {
  ExcludeTopologies -> {Snails, WFCorrectionCTs, TadpoleCTs, Loops[6]},
  Adjacencies -> {3, 4}
};

InsertFieldsOptions = {
  Model -> {"SMQCD", "SMQCDR2"},
  GenericModel -> "Lorentz",
  InsertionLevel -> {Particles},
  Restrictions -> {ExcludeParticles -> {S[2 | 3]}, NoQuarkMixing}
};

UnitaryGauge = True;

ColourCorrelations = False;

SubProcessName = Automatic;

SelectCoupling = MemberQ[{3}, Exponent[#1, eQED]] & ;

SelectInterference = {
  eQED -> {6}
};

SelectTreeDiagrams = False & ;

SelectLoopDiagrams = ContainsFermionLoop;

SelectCTDiagrams = NFieldPropagators[V[5], 1];

ReplaceOSw = False;

SetParameters = {
  ME -> 0,
  YE -> 0,
  YukB -> 1,
  YukT -> 1,
  nc -> 3,
  nf -> 6,
  MU -> 0,
  MD -> 0,
  MS -> 0,
  MC -> 0,
  YU -> 0,
  YD -> 0,
  YS -> 0,
  YC -> 0,
  LeadingColour -> 0,
  POLSEL -> 1
};

ChannelMap = {
  {"nenexddxhg"},
  {"nenexbbxhg", "MB=0", "YB=0"}
};

Approximation = "";

ForceLoops = Automatic;

NonZeroHels = Null;
