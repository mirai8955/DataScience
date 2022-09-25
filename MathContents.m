x = -4*pi:0.01:4*pi;

%bump
% figure;
% x1 = [-7*pi,x,7*pi];
% y = (-cos(x/4) - 1)/2;
% y1 = [0 y 0];
% hold on
% plot(x1,y1,'Linewidth',1.5)
% pbaspect([9 1 1])
% colororder([0.85 0.33 0.10])
% ylim([-1.5 0.5])
% hold off

%texture
% figure;
% hold on
% y=sin(8*x)/6 - 1/6;
% x2 = [-7*pi -4*pi x 4*pi 7*pi];
% y2 = [0 0 y 0 0];
% plot(x2,y2,'Linewidth',1.5)
% pbaspect([9 1 1])
% ylim([-1 1])
% colororder([0.85 0.33 0.10])
% hold off

%bump + texture
% figure;
% hold on
% y=( sin(8*x)/6 - 1/6 ) + (cos(x/4) + 1)/2;
% x3 = [-7*pi -4*pi x 4*pi 7*pi];
% y3 = [0 0 y 0 0];
% plot(x3,y3,'Linewidth',1.5)
% pbaspect([9 1 1])
% ylim([-0.5 1.5])
% colororder([0.85 0.33 0.10])
% hold off

%dent + texture
% figure;
% hold on
% y=( sin(8*x)/6 - 1/6 ) + (-cos(x/4) - 1)/2;
% x4 = [-7*pi -4*pi x 4*pi 7*pi];
% y4 = [0 0 y 0 0];
% plot(x4,y4,'Linewidth',1.5)
% pbaspect([9 1 1])
% ylim([-1.5 0.5])
% colororder([0.85 0.33 0.10])
% hold off


%2倍sin波
% figure;
% x = -pi:0.01:0;
% xn = 0:0.01:pi;
% hold on
% x1 = [ -1.5*pi x ];
% x2 = [xn 1.5*pi];
% y = power(sin(x),2)*4/5;
% y1 = [0 y];
% y2 = [-y 0];
% plot(x1,y1,'Linewidth',2.5,'Color',	'#0072BD')
% plot(x2,y2,'Linewidth',2.5,'Color',	'#0072BD')
% ylim([-1 1])
% hold off

%1.5倍sin波
% figure;
% x = -pi:0.01:0;
% xn = 0:0.01:pi;
% hold on
% x1 = [ -1.5*pi x];
% x2 = [xn 1.5*pi];
% x3 = 0;
% y = power(sin(x),1.5)*4/5;
% y1 = [0 y];
% real_y1 = real(y1);
% imag_y1 = imag(y1);
% y2 = [-y 0];
% y3 = 0;
% real_y2 = real(y2);
% imag_y2 = imag(y2);
% %plot(x1,real_y1,x1,imag_y1,x2,real_y2,x2,imag_y2,'Linewidth',2.5,'Color','#0072BD')
% plot(x1,imag_y1,x3,y3,x2,imag_y2,'Linewidth',2.5,'Color','#0072BD')
% ylim([-1 1])
% hold off


%0.7倍sin波
% figure;
% x = -pi:0.01:0;
% xn = 0:0.01:pi;
% hold on
% x1 = [ -1.5*pi x];
% x2 = [xn 1.5*pi];
% x3 = [-0.01 0 0.01];
% y = power(sin(x),0.7)*4/5;
% y1 = [0 y];
% real_y1 = real(y1);
% imag_y1 = imag(y1);
% y2 = [-y 0];
% y3 = sin(x3);
% real_y2 = real(y2);
% imag_y2 = imag(y2);
% %plot(x1,real_y1,x1,imag_y1,x2,real_y2,x2,imag_y2,'Linewidth',2.5,'Color','#0072BD')
% plot(x1,imag_y1,x3,y3,x2,imag_y2,'Linewidth',2.5,'Color','#0072BD')
% ylim([-1 1])
% hold 


%3.0倍sin波
figure;
x = -pi:0.01:0;
xn = 0:0.01:pi;
hold on
x1 = [ -1.5*pi x ];
x2 = [xn 1.5*pi];
y = power(sin(x),3.0)*4/5;
y1 = [0 y];
y2 = [-y 0];
plot(x1,y1,'Linewidth',2.5,'Color',	'#0072BD')
plot(x2,y2,'Linewidth',2.5,'Color',	'#0072BD')
ylim([-1 1])
hold off







