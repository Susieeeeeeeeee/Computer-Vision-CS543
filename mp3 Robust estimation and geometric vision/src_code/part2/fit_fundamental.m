function F = fit_fundamental(x1,x2,nor)

N = size(x1,2);

if (nor == 2)
    [x1,T1] = normalize(x1);
    [x2,T2] = normalize(x2);
end

% build the constraint matrix
A=[];
for i=1:2
    A=[A; x2(i,:).*x1(1,:); x2(i,:).*x1(2,:); x2(i,:)];
end
A = [A;x1(1:2,:);ones(1,N)];
 
[~,~,V] = svd(A');
f = V(:,end);
F = reshape(f, [3,3])';


% rank-2 constraint
[U,D,V] = svd(F);
D(end,end) = 0;
F = U * D * V';

if (nor == 2)
% transform fundamental matrix back to original units
    F = T2' * F * T1;
end
end