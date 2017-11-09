rm(list = ls())

source("./lib/ProcessosEstocasticos.r");

z0=0
t = 10;

## Wiener Process

dt = 1;
cat(sprintf("z0=%d T=%d dt=%0.4f\n", z0, t, dt));
z = WienerProcess(z0, t, dt);
dz = diff(z);
cat(sprintf("z0=%d T=%d dt=%0.4f mean(dz)=%.4f var(dz)=%.4f\n", z0, t, dt, mean(dz), var(dz)));
PlotProcess(z);

dt = 0.1
cat(sprintf("z0=%d T=%d dt=%0.4f\n", z0, t, dt));
z = WienerProcess(z0, t, dt);
dz = diff(z);
cat(sprintf("z0=%d T=%d dt=%0.4f mean(dz)=%.4f var(dz)=%.4f\n", z0, t, dt, mean(dz), var(dz)));
PlotProcess(z);

dt = 0.01
cat(sprintf("z0=%d T=%d dt=%0.4f\n", z0, t, dt));
z = WienerProcess(z0, t, dt);
dz = diff(z);
cat(sprintf("z0=%d T=%d dt=%0.4f mean(dz)=%.4f var(dz)=%.4f\n", z0, t, dt, mean(dz), var(dz)));
PlotProcess(z);

dt = 0.001;
a = 4;
b= 1.5;
z = GeneralWienerProcess(z0, a, b, t, dt);
dz = diff(z);
PlotProcess(z);

cat(sprintf("z0=%d T=%d dt=%0.4f a=%0.2f b=%0.2f mean(dz)=%.4f var(dz)=%.4f\n", z0, t, dt, a, b, mean(dz), var(dz)));


