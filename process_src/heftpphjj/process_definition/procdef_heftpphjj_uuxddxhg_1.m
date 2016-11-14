
FeynArtsProcess = {F[3, {1}], -F[3, {1}]} -> {-F[4, {1}], F[4, {1}], S[1], V[5]};

SortExternal = True;

OpenLoopsModel = "HEFT";

CreateTopologiesOptions = {
  ExcludeTopologies -> {Snails, WFCorrectionCTs, TadpoleCTs},
  Adjacencies -> {3, 4, 5, 6}
};

InsertFieldsOptions = {
  Model -> {"HEFT", "HEFTR2"},
  GenericModel -> "HEFT",
  InsertionLevel -> {Particles},
  Restrictions -> {ExcludeParticles -> {S[2 | 3], F[3, {3}]}, NoQuarkMixing}
};

UnitaryGauge = True;

ColourCorrelations = Automatic;

SubProcessName = Automatic;

SelectCoupling = MemberQ[{1}, Exponent[#1, eQED]] & ;

SelectInterference = {
  eQED -> {2}
};

SelectTreeDiagrams = True & ;

SelectLoopDiagrams = True & ;

SelectCTDiagrams = True & ;

ReplaceOSw = False;

SetParameters = {
  nc -> 3,
  nf -> 5,
  MU -> 0,
  MD -> 0,
  MS -> 0,
  MC -> 0,
  LeadingColour -> 0,
  POLSEL -> 1
};

ChannelMap = {
  {"ddxbbxhg", "MB=0"},
  {"uuxbbxhg", "MB=0"},
  {"ddxssxhg"},
  {"uuxccxhg"},
  {"ccxddxhg"}
};

Approximation = "";

ForceLoops = "t";

NonZeroHels = Null;
