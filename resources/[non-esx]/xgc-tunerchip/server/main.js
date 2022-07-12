let tac = null;

let checktac = setInterval(() => {
  if (tac === null) {
    emit("tac:getSharedObject", (obj) => tac = obj);
    tac.RegisterUsableItem("tunerchip", (source) => {
      emitNet("xgc-tuner:openTuner", source)
    });
    clearInterval(checktac);
  }
}, 500);