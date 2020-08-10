%v1 = 0; %Geschwindigkeit Fahrzeug 1 in Zellen pro Runde. 1 Zelle = 7,5m 1 Runde = 1s 
%v2 = 0; %Geschwindigkeit Fahrzeug 2 
%v3 = 0; %Geschwindigkeit Fahrzeug 3

%Falls die Maximalgeschwindigkeit eines Fahrzeuges noch nicht erreicht ist, wird seine Geschwindigkeit um eins erhöht
%if v1 < 5
%    v1 = v1 + 1;
%end
%if v2 < 5
%    v2 = v1 + 1;
%end
%if v2 < 5
%    v2 = v1 + 1;
%end

%erster Ansatz mit 3 Autos zu einfach, schlecht Skalierbar auf beliebige
%Anzahl Autos. Deswegen neuer Ansatz:

Anzahl_Autos = 4;
Laenge_Strasse = 15;    %10 Felder a 7,5m
Anzahl_Runden = 8;
Troedelfaktor = 1/3;    % Zahl von 0 bis 1 in 0,1 Schritten
vp_Auto = zeros(Anzahl_Autos,2);         %Geschwindigkeit und Position der Autos in einem Skalierbaren Feld gespeichert
Strasse = zeros(1,Laenge_Strasse);%Die Position der Autos wird für die Update Regeln und die Ausgabe in einem Skalierbaren Feld gespeichert
%im Ausgabefeld werden die Autos anhand ihrer Geschwindigkeit dargestellt.
%Felder in denen kein Auto ist sollte mit "-" dargestellt sein. Da ich
%gerade keine Ahnung habe wie man Zeichen statt Zahlen in dem Feld
%speichert und Nullen ungünstig sind, da sie mit einem Auto der
%Geschwindigkeit 0 verwechselt werden können. Schreibe ich in das Feld an
%jede Stelle, wo kein Auto ist, eine 8. (liegt über der
%Höchstgeschwindigkeit)
i = 1;
while (i<=Laenge_Strasse)
    Strasse(1,i)=8;
    i = i+1;
end

%Autos zufällig auf der Straße positionieren:
i=1;
while (i<=Anzahl_Autos)
    p = randi(Laenge_Strasse,1);     %es wird eine zufällige Zahl generiert, die für den Platz des Autos auf der Straße steht
    if (Strasse(1,p)== 8)            %dem Auto soll nur eine freie Position zugewiesen werden. Verhindert, dass nicht zwei Autos zufällig dem selben Feld zugeordnet werden 
        Strasse(1,p) = vp_Auto(i,1); %das Auto wird mit seiner Geschwindigkeit auf der Straße dargestellt
        vp_Auto(i,2)= p;             %die Position des Autos wird gespeichert 
        i=i+1;                       %i wird nur hoch gezählt, wenn eine freie Position für das Auto gefunden wurde. Wenn keine freie Position gefunden wurde, läuft die Schleife nochmal und generiert einen neuen Zufallsplatz
    end
end
   Schritt0 = Strasse
   Runde=1
 while (Runde<=Anzahl_Runden)
%1.) Falls die Maximalgeschwindigkeit eines Fahrzeuges noch nicht erreicht ist, 
%wird seine Geschwindigkeit um 1 erhöht

i=1;
while(i<=Anzahl_Autos)              %die Schleife geht jedes Auto durch
    if (vp_Auto(i,1)<5)
        vp_Auto(i,1)= vp_Auto(i,1)+1;  %und erhöht die Geschwindigkeit jedes Autos um 1, solange die Höchstgeschwindigkeit noch nicht erreicht ist.
        Strasse(1,vp_Auto(i,2)) = vp_Auto(i,1); %Die geschwindigkeitsdarstellung des Autos auf der Straße wird auf seiner Position aktualisiert
    end
    i = i+1;
end
v_erhoeht = Strasse

%2.) Falls die Lücke (in Zellen) zum nächsten Fahrzeug kleiner ist als die Geschwindigkeit (in Zellen pro Runde), 
%wird die Geschwindigkeit des Fahrzeugs auf die Größe der Lücke reduziert. (Kollisionsfreiheit)
%i=1;
%while (i<=Anzahl_Autos)
%    Abstand = 0;
%    p = vp_Auto(i,2);   %Position des Aktuellen Autos
%   if (p+1 <= Laenge_Strasse)
%    while (Strasse(p+1,1)==8)
%        Abstand = Abstand + 1;
%        if (p+1 <= Laenge_Strasse - 1)
%            p = p+1; %von der Position des Autos aus, wird immer die nächste Stelle angeschaut
%        end
%    end
%  end
%    if (Abstand < vp_Auto(i,1))
%        vp_Auto(i,1)= Abstand;
%    end
%    i=i+1;
%end
        
i=1;
while (i<=Anzahl_Autos)
    Abstand = Laenge_Strasse;
    p = vp_Auto(i,2);   %Position des Aktuellen Autos
    k=1;
    while (k<=Anzahl_Autos)     %die Position des Aktuellen Autos wird mit allen anderen Positionen verglichen
        if (vp_Auto(k,2)>p && vp_Auto(k,2)-p < Abstand) %interessant sind nur die Positionen vor dem Aktuellen Auto und nur, wenn diese Position näher ist, als der bisher kleinste ermittelte Abstand zum Vordermann
            Abstand = vp_Auto(k,2)-p;                    %dadurch wird der kleinste Abstand zu einem der voraus Fahrenden Autos ermittelt
        end
        
        
        if (Abstand-1 < vp_Auto(i,1))     %wenn dieser Abstand-1 kleiner ist als die Geschwindigkeit des Autos
            vp_Auto(i,1)= Abstand-1;          %wird die Geschwindigkeit auf den Wert des Abstandes-1 reduziert
            Strasse(1,vp_Auto(i,2)) = vp_Auto(i,1); %Die geschwindigkeitsdarstellung des Autos auf der Straße wird auf seiner Position aktualisiert
        end
        k = k+1;
    end
    i=i+1;
end    
automatisch_bremsen = Strasse

%3.) Die Geschwindigkeit eines Fahrzeugs wird mit der Wahrscheinlichkeit des Trödelfaktors um eins reduziert, sofern es nicht schon steht (Trödeln).
i=1;
while (i<=Anzahl_Autos)
    z = randi(10,1);        %generiert eine Zufallszahl zwischen 1 und 10
    if (z<Troedelfaktor*10) %erzeugt die gewünschte Wahrscheinlichkeit des Trödelfaktors
        if vp_Auto(i,1)>0
            vp_Auto(i,1)=vp_Auto(i,1)-1;
            Strasse(1,vp_Auto(i,2)) = vp_Auto(i,1); %Die geschwindigkeitsdarstellung des Autos auf der Straße wird auf seiner Position aktualisiert
        end
    end
    i=i+1;
end
Troedeln = Strasse

%4.) Alle Fahrzeuge werden ihrer momentanen Geschwindigkeit entsprechend vorwärts bewegt.
i=1;
while (i<=Anzahl_Autos)
    Strasse(1,vp_Auto(i,2))=8;
    if (vp_Auto(i,2)+vp_Auto(i,1) <= Laenge_Strasse)
            vp_Auto(i,2)= vp_Auto(i,2)+vp_Auto(i,1);
            Strasse(1,vp_Auto(i,2))= vp_Auto(i,1);
    else
         vp_Auto(i,2)= vp_Auto(i,2)+vp_Auto(i,1)-Laenge_Strasse; %Autos, die weiter als die länge der Straße fahren, fangen vorne wieder an..Gefahr des überschreibens wenn vorne noch einer steht noch nicht gelöst
        Strasse(1,vp_Auto(i,2))= vp_Auto(i,1);
    end
     i = i+1;
end
vorwaerts = Strasse
x = vp_Auto(:,2);
y = vp_Auto(:,1);  
scatter(x,y)
pause(3)
%scatter(vp_Auto(i,1),vp_Auto(i,2));

Runde =Runde+1
 end

