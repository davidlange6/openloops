
FeynArtsProcess = {F[1, {1}], F[1, {2}]} -> {F[2, {1}], F[2, {2}], F[3, {1}], F[3, {1}], -F[4, {1}], -F[4, {1}]};

SortExternal = True;

OpenLoopsModel = "SM";

CreateTopologiesOptions = {
  ExcludeTopologies -> {Snails, WFCorrectionCTs, TadpoleCTs},
  Adjacencies -> {3, 4}
};

InsertFieldsOptions = {
  Model -> {"SMQCD", "SMQCDR2"},
  GenericModel -> "Lorentz",
  InsertionLevel -> {Particles},
  Restrictions -> {ExcludeParticles -> {}, NoQuarkMixing}
};

UnitaryGauge = False;

ColourCorrelations = Automatic;

SubProcessName = Automatic;

SelectCoupling = Exponent[#1, eQED] === 6 & ;

SelectInterference = {
  eQED -> {12}
};

SelectTreeDiagrams = True & ;

SelectLoopDiagrams = SameQuarkLineGluon;

SelectCTDiagrams = NFieldPropagators[V[5], 0];

ReplaceOSw = False;

SetParameters = {
  ME -> 0,
  MM -> 0,
  CKMORDER -> 0,
  nc -> 3,
  nf -> 6,
  MU -> 0,
  MD -> 0,
  MS -> 0,
  MC -> 0,
  LeadingColour -> 0,
  POLSEL -> 1
};

ChannelMap = {};

Approximation = "vbs";

ForceLoops = Automatic;

NonZeroHels = Null;