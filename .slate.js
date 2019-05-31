// Configs
S.cfga({
  "defaultToCurrentScreen" : true,
  "secondsBetweenRepeat" : 0.1,
  "checkDefaultsOnLoad" : true,
  "focusCheckWidthMax" : 3000,
  "orderScreensLeftToRight" : true
});

// Monitors
var monTbolt  = "3440x1440";
var monLaptop = "1920x1080";

// Operations
var lap = S.op("move", {
  "screen" : monLaptop,
  "x" : "screenOriginX",
  "y" : "screenOriginY",
  "width" : "screenSizeX",
  "height" : "screenSizeY"
});
var full = S.op("move", {
  "screen" : monTbolt,
  "x" : "screenOriginX",
  "y" : "screenOriginY",
  "width" : "screenSizeX",
  "height" : "screenSizeY"
});

var lapLeft = lap.dup({ "width" : "screenSizeX/2" });
var lapRight = lapLeft.dup({ "x" : "screenOriginX+screenSizeX/2"})
var triLeft = full.dup({ "width" : "screenSizeX/3" });
var triMid = triLeft.dup({ "x" : "screenOriginX+screenSizeX/3" });
var triRight = triLeft.dup({ "x" : "screenOriginX+(screenSizeX*2/3)" });
var quadLeft = full.dup({ "width" : "screenSizeX/4" });
var quadLeftMid = quadLeft.dup({ "x" : "screenOriginX+screenSizeX/4" });
var quadRightMid = quadLeft.dup({ "x" : "screenOriginX+(screenSizeX*1/2)" });
var quadRight = quadLeft.dup({ "x" : "screenOriginX+(screenSizeX*3/4)" });

// Batch bind everything. Less typing.
S.bnda({

  // Basic Location Bindings
  "[:ctrl" : lapLeft,
  "]:ctrl" : lapRight,
  "1:ctrl" : triLeft,
  "2:ctrl" : triMid,
  "3:ctrl" : triRight,
  "7:ctrl" : quadLeft,
  "8:ctrl" : quadLeftMid,
  "9:ctrl" : quadRightMid,
  "0:ctrl" : quadRight,

  // Resize Bindings
  // NOTE: some of these may *not* work if you have not removed the expose/spaces/mission control bindings
  "right:ctrl" : S.op("resize", { "width" : "+10%", "height" : "+0" }),
  "left:ctrl" : S.op("resize", { "width" : "-10%", "height" : "+0" }),
  "up:ctrl" : S.op("resize", { "width" : "+0", "height" : "-10%" }),
  "down:ctrl" : S.op("resize", { "width" : "+0", "height" : "+10%" }),
  "right:alt" : S.op("resize", { "width" : "-10%", "height" : "+0", "anchor" : "bottom-right" }),
  "left:alt" : S.op("resize", { "width" : "+10%", "height" : "+0", "anchor" : "bottom-right" }),
  "up:alt" : S.op("resize", { "width" : "+0", "height" : "+10%", "anchor" : "bottom-right" }),
  "down:alt" : S.op("resize", { "width" : "+0", "height" : "-10%", "anchor" : "bottom-right" }),

  // Nudge Bindings
  // NOTE: some of these may *not* work if you have not removed the expose/spaces/mission control bindings
  "right:ctrl;cmd" : S.op("nudge", { "x" : "+10%", "y" : "+0" }),
  "left:ctrl;cmd" : S.op("nudge", { "x" : "-10%", "y" : "+0" }),
  "up:ctrl;cmd" : S.op("nudge", { "x" : "+0", "y" : "-10%" }),
  "down:ctrl;cmd" : S.op("nudge", { "x" : "+0", "y" : "+10%" }),

  // Focus Bindings
  // NOTE: some of these may *not* work if you have not removed the expose/spaces/mission control bindings
  "l:cmd" : S.op("focus", { "direction" : "right" }),
  "h:cmd" : S.op("focus", { "direction" : "left" }),
  "k:cmd" : S.op("focus", { "direction" : "behind" }),
  "j:cmd" : S.op("focus", { "direction" : "behind" }),

  // Window Hints
  "esc:cmd" : S.op("hint"),

  // Switch currently doesn't work well so I'm commenting it out until I fix it.
  //"tab:cmd" : S.op("switch"),

  // Grid
  "esc:ctrl" : S.op("grid")
});

// Test Cases
S.src(".slate.test", true);
S.src(".slate.test.js", true);

// Log that we're done configuring
S.log("[SLATE] -------------- Finished Loading Config --------------");
