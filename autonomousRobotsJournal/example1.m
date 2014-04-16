x = [0 10 20 30 40 50];
y = [0 0 0 0 0 0];
a = 0;

for i = 1:6
    y(i) = a + x(i);
end

plot(x, y);