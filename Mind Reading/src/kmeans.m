
%________kmeans__________________________________________________________

function kmeans(classesAveraged, averaged)
rng default; % For reproducibility

X = [averaged'];
[idx, C] = kmeans(X, 4);
figure;
plot(classesAveraged);
plot(idx); 
hold on;
plot(classesAveraged,'.r');
hold off;

% figure;
% plot(X(idx==1,1), X(idx==1,2), 'r.', 'MarkerSize', 12)
% hold on
% plot(X(idx==2,1), X(idx==2,2), 'b.', 'MarkerSize', 12)
% hold on
% plot(X(idx==3,1), X(idx==3,2), 'g.', 'MarkerSize', 12)
% hold on
% plot(X(idx==4,1), X(idx==4,2), 'y.', 'MarkerSize', 12)
% hold on;
% plot(C(:,1),C(:,2),C(:,3), C(:,4), 'kx','MarkerSize',15,'LineWidth',3)
% legend('Cluster 1', 'Cluster 2', 'Cluster 3', 'Cluster 4', 'Centroids')
% title 'kmeans clustering'
% hold off

end
