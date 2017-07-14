function [ out ] = analyzeERPs( d )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
 figure;
 hold on;
 pointsCombined = [];
 pointsCombined1 = [];
 pointsCombined2 = [];
 pointsCombined3 = [];
 pointsCombined4 = [];
%Loop through d.
 for k = 1:size(d, 2)
    
%Loop through ERP
    for i = 1:length(d{k}.erp)
       

%Find the 3 relevant ponits.
        for l = 1:5
       
           x = max(d{k}.erp{i}.data( find( d{k}.erp{i}.t > 0.000 & d{k}.erp{i}.t < 0.150 ),l));
           y = min(d{k}.erp{i}.data( find( d{k}.erp{i}.t > 0.100 & d{k}.erp{i}.t < 0.300 ),l));
           z = min(d{k}.erp{i}.data( find( d{k}.erp{i}.t > 0.350 & d{k}.erp{i}.t < 0.550 ),l));

           
           
           
%    Plot channels        
%            if l == 1
%                 scatter3(x,y,z,'g');
%            elseif l ==2
%                 scatter3(x,y,z,'y');
%            elseif l ==3
%                 scatter3(x,y,z,'b');
%            elseif l==4
%                 scatter3(x,y,z,'r');
%            else
%                 scatter3(x,y,z,'k');
%            end
%    Plot classes
           if i == 1
                scatter3(x,y,z,'r');
                % scatter(x,y,'r');
                points = [x, y, z];
                pointsWithLabels = [1; points(:)];
                pointsCombined1 = [pointsCombined1 pointsWithLabels];
                
           elseif i ==2
                scatter3(x,y,z,'b');
               %  scatter(x,y,'b');
                points = [x, y, z];
                pointsWithLabels = [2; points(:)];
                pointsCombined2 = [pointsCombined2 pointsWithLabels];
                
           elseif i ==3
                scatter3(x,y,z,'k');
               % scatter(x,y,'k');
               points = [x, y, z];
                pointsWithLabels = [3; points(:)];
                pointsCombined3 = [pointsCombined3 pointsWithLabels];
                
           else
               scatter3(x,y,z,'g');
               % scatter(x,y,'g');
               points = [x, y, z];
                pointsWithLabels = [4; points(:)];
                pointsCombined4 = [pointsCombined4 pointsWithLabels];
           end
        end
    end    
        
 end
       hold off;  
       for k = 1:25
           pointsCombined = [pointsCombined pointsCombined1(:,k) pointsCombined2(:,k) pointsCombined3(:,k) pointsCombined4(:,k)];
       end
end

% plot( d{1}.erp{1}.data( find( d{1}.erp{1}.t > 0.100 & d{1}.erp{1}.t < 0.250 )) )