# aerostats, balloons, and airships

modeling the aerostatic lift and aerodynamic drag to predict the vertical motion of hot air balloons

# properties

```c
float altitude;
float mass;
float weight;
float volume;
float temperature;   // ambient internal balloon temperature
float drag_coef;     // coefficient of drag, .4 for typical hot air balloon
float S;             // horizontal cross sectional area of balloon at maximum diameter
float velocity;      // vertical velocity
float acceleration;  // vertical acceleration
```

# dependencies

[international standard atmosphere](https://github.com/PacificSpaceflight/ISA)

# sources

William Yeong, Liang Ling “A.4.2.1.3.2 Derivation of Basic Balloon Flight Dynamics”

Karl Stefan “Performance Theory for Hot Air Balloons”

# license

MIT