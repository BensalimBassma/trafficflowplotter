%%file trafficflow.m
function [v_ave,q_ave] = trafficflow(density,max_speed,p_SF)

len         = 1000;   % the length of the road [cells] (1000)
T           = 3600;    % the simulation time [seconds] (3600)

    %<<<<<< ADD YOUR CODE HERE >>>>>>%

%% initial configuration
sum_vel = 0;                    %Summe aller Geschwindigkeiten - wird später in der Schleife zur Berechnung der Durchschnittsgeschwindigkeit gebraucht
divisor = 0;                    %wird später in der Schleife zur Berechnung der Durchschnittsgeschwindigkeit gebraucht
zaehler = 0;                    %Zählt die Autos die das Ende der Straße verlassen und am Anfang wieder anfangen. Wird zur Berechnung des Verkehrsflusses benötigt
n = floor(len*density);         %Anzahl der Autos - gerundet auf ganze Autos mit floor
pos = sort(randperm(len, n))    %Positionen der Autos - aufsteigend sortiert
vel = zeros(1,n)                %Geschwindigkeiten der Autos
Strasse = zeros(1,len);%Die Position der Autos wird für die Update Regeln und die Ausgabe in einem Skalierbaren Feld gespeichert
%im Ausgabefeld werden die Autos anhand ihrer Geschwindigkeit dargestellt.
%Felder in denen kein Auto ist sollte mit "-" dargestellt sein. Da ich
%gerade keine Ahnung habe wie man Zeichen statt Zahlen in dem Feld
%speichert und Nullen ungünstig sind, da sie mit einem Auto der
%Geschwindigkeit 0 verwechselt werden können. Schreibe ich in das Feld an
%jede Stelle, wo kein Auto ist, eine 8. (liegt über der
%Höchstgeschwindigkeit)
i = 1;
while (i<=len)
    Strasse(1,i)=8;
    i = i+1;
end
%Autos mit ihrer Geschwindigkeit an der jeweilligen Stelle auf der Straße
%positionieren:
i=1;
while (i<=n)
    Strasse(1,pos(1,i))=vel(1,i);
    i=i+1;
end
%Schritt0 = Strasse %Ausgabe zur Kontrolle


%% main time loop
for t=1:T
    %1.) increase speed of all cars by one
        % Falls die Maximalgeschwindigkeit eines Fahrzeuges noch nicht erreicht ist, 
        %wird seine Geschwindigkeit um 1 erhöht

    i=1;
    while(i<=n)              %die Schleife geht jedes Auto durch
        if (vel(1,i)<max_speed)
            vel(1,i)= vel(1,i)+1;  %und erhöht die Geschwindigkeit jedes Autos um 1, solange die Höchstgeschwindigkeit noch nicht erreicht ist.
 %           Strasse(1,pos(1,i)) = vel(1,i); %Die geschwindigkeitsdarstellung des Autos auf der Straße wird auf seiner Position aktualisiert
        end
        i = i+1;
    end
  % vel_erhoeht = Strasse %Ausgabe zur Kontrolle
    
    %2.) decrease speed if it would cause a collision otherwise
        i=1;
        while(i<=n)              %die Schleife geht jedes Auto durch
            if (i+1 <= n)        %index von Pos(i) darf n nicht überschreiten. Sonderfall für das letzte Auto
                if (pos(i+1)>pos(i))    %Normalfall, Sonderfall beim Vergleich des letzten Autos auf der Straße mit 1.Auto auf der Straße 
                    Abstand = pos(i+1)-pos(i);
                    if (Abstand-1 < vel(1,i))        %wenn dieser Abstand-1 kleiner ist als die Geschwindigkeit des Autos
                        vel(1,i)= Abstand-1;          %wird die Geschwindigkeit auf den Wert des Abstandes-1 reduziert
  %                      Strasse(1,pos(1,i)) = vel(1,i); %Die geschwindigkeitsdarstellung des Autos auf der Straße wird auf seiner Position aktualisiert
                    end
                else
                    Abstand = len-pos(i)+pos(i+1);   %Sonderfall der Abstandsberechnung wenn das aktuelle Auto am Ende der Straße ist und das nächste Auto am Anfang der Straße
                    if (Abstand-1 < vel(1,i))        %wenn dieser Abstand-1 kleiner ist als die Geschwindigkeit des Autos
                        vel(1,i)= Abstand-1;          %wird die Geschwindigkeit auf den Wert des Abstandes-1 reduziert
%                        Strasse(1,pos(1,i)) = vel(1,i); %Die geschwindigkeitsdarstellung des Autos auf der Straße wird auf seiner Position aktualisiert
                    end
                end
                
             else
               % Abstand = pos(1)-pos(i)          %Sonderfall, wenn der Abstand des letzten Autos mit dem des 1. Autos verglichen wird
                    
                if (pos(1)>pos(i))                %Normalfall, Sonderfall beim Vergleich des letzten Autos auf der Straße mit 1.Auto auf der Straße 
                    Abstand = pos(1)-pos(i);
                     if (Abstand-1 < vel(1,i))        %wenn dieser Abstand-1 kleiner ist als die Geschwindigkeit des Autos
                        vel(1,i)= Abstand-1;          %wird die Geschwindigkeit auf den Wert des Abstandes-1 reduziert
%                        Strasse(1,pos(1,i)) = vel(1,i); %Die geschwindigkeitsdarstellung des Autos auf der Straße wird auf seiner Position aktualisiert
                    end
                else
                    Abstand = len-pos(i)+pos(1);   %Sonderfall der Abstandsberechnung wenn das aktuelle Auto am Ende der Straße ist und das nächste Auto am Anfang der Straße
                    if (Abstand-1 < vel(1,i))         %wenn dieser Abstand-1 kleiner ist als die Geschwindigkeit des Autos
                        vel(1,i)= Abstand-1 ;           %wird die Geschwindigkeit auf den Wert des Abstandes-1 reduziert
%                        Strasse(1,pos(1,i)) = vel(1,i); %Die geschwindigkeitsdarstellung des Autos auf der Straße wird auf seiner Position aktualisiert
                    end
                end
            end
            i=i+1;
        end
        
%        automatisch_bremsen = Strasse %Ausgabe zur Kontrolle

    
    %3.) decrease velocity of a random selection 
    %    of p_SF*num_cars by 1
       SF = randperm(n,floor(p_SF*n)); %erzeugt einen Vektor mit allen Sonntagsfahrern entsprechend dem Anteil p_SF an allen Autos n.. floor rundet diesen Wert auf ganze autos
       i=1;
       while(i<=floor(p_SF*n))         %Schleife geht alle Sonntagsfahrer durch    
           if (vel(SF(i))>0)    %falls die Geschwindigkeit dieses Sonntagsfahrers größer 0 ist
               vel(SF(i))=vel(SF(i))-1;               %verrigere seine Geschwindigkeit um 1
%               Strasse(1,pos(1,SF(i)))= vel(1,SF(i));   %Die geschwindigkeitsdarstellung des Autos auf der Straße wird auf seiner Position aktualisiert
           end
           i=i+1;
       end
       
       %Troedeln = Strasse %Ausgabe zur Kontrolle
       
    %4.) move cars according to their speed

        % Alle Fahrzeuge werden ihrer momentanen Geschwindigkeit entsprechend vorwärts bewegt.
    i=1;
    while (i<=n)
%         Strasse(1,pos(1,i))=8;                 %alte Position des Autos resetten
        if (pos(1,i)+vel(1,i) <= len)           %aufpassen, dass die Position des Autos+ seine Geschwindigkeit nicht mehr ist als die länge der Straße
                pos(1,i)= pos(1,i)+vel(1,i);    %Position des autos wird der entsprechenden Geschwindigkeit nach aktualisiert
 %               Strasse(1,pos(1,i))= vel(1,i);   %Die geschwindigkeitsdarstellung des Autos auf der Straße wird auf seiner Position aktualisiert
        else
            pos(1,i)= pos(1,i)+vel(1,i)-len; %Autos, die weiter als die länge der Straße fahren, fangen vorne wieder an..Gefahr des überschreibens gelöst, da vorher geschwindigkeit reduziert
%            Strasse(1,pos(1,i))= vel(1,i); %Die geschwindigkeitsdarstellung des Autos auf der Straße wird auf seiner Position aktualisiert
            zaehler = zaehler+1;             %Zählt die Autos die das Ende der Straße verlassen und am Anfang wieder anfangen. Wird zur Berechnung des Verkehrsflusses benötigt
        end
        i = i+1;
    end
%    vorwaerts = Strasse %Ausgabe zur Kontrolle
    %5.) animate
    
     %   x = pos(:);
     %   y = ones(1,n);  
     %       scatter(x,y,"filled")
     %       pause(0.1)
            
            %Berechnung der Durchschnittsgeschwindigkeit vorbereiten
            sum_vel = sum(vel(:))+ sum_vel;  %in jeder Runde werden alle Geschwindigkeiten aufaddiert
            divisor = n + divisor;  %am Ende müssen Sie für den Durchschnitt durch die Anzahl an Geschwindigkeiten geteilt werden
end
    %Durchschnittsgeschwindigkeit berechnen und ausgeben
    sum_vel
    divisor
    v_ave = sum_vel/divisor
    %Trafficflow berechnen und ausgeben
    q_ave = zaehler/T 
end