%% input parameters
max_speed   = 3;      % the maximally possible speed [cells/second]
p_SF        = 0.20;   % the ratio of 'sunday drivers'
density = 0.05;       % Verkehrsdichte

y2=zeros(20,1);     %Diagramm2: y-Achse - Speicherplatz für Verkehrsfluss
y=zeros(20,1);      %Diagramm1: y-Achse - Speicherplatz für Durchschnittsgeschwindigkeiten
x=zeros(20,1);      %x-Achse - Speicherplatz für Verkehrsdichte

    %<<<<<< ADD YOUR CODE HERE >>>>>>%
    
%% main loop
i=1;
while (density <= 1.01)
    x(i)=density;                       %Die Verkehrsdichte wird in einem Vektor für die x-Achse gespeichert
    [v_ave, q_ave] = trafficflow(density,max_speed,p_SF) %für jede Verkehrsdichte wird die funktion Trafficflow aufgerufen und die jeweillige Durchschnittsgeschwindigkeit und Trafficflow ausgegeben
    y(i)=v_ave;                         %Die Durchschnittsgeschwindigkeiten werden in einem Vektor für die Y-Achse gespeichert
    y2(i)=q_ave                         %Der Trafficflow wird in einem Vektor für die Y-Achse im 2. Diagramm gespeichert
    density = density + 0.05;           %bei jedem Schleifendurchlauf erhöhrt sich die Verkehrsdichte um 0.05
    i=i+1;
end

%Erstellung der Diagramme

figure(2)
subplot(1,2,1);

%3.) plot density vs. maximal velocity

    %<<<<<< ADD YOUR CODE HERE >>>>>>%
plot(x,y.*7.5*3.6)    %Einheit der Geschwindigkeit von "7,5m Streckenabschnitte pro sekunde" auf km/h umgerechnet
title('density vs. average velocity');
xlabel('normalized density')
ylabel('average velocity [km/h]')

subplot(1,2,2); 

%4.) plot density vs. traffic flow
    
    %<<<<<< ADD YOUR CODE HERE >>>>>>%

plot(x,y2)
title('density vs. traffic flow');
xlabel('normalized density')
ylabel('traffic flow [cars/second]')