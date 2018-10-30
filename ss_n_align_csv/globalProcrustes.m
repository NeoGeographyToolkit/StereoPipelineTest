function [R, t, s, Centroid, corr, Model, Trans] = globalProcrustes(Model, nMaxSteps, transOnly)
% [R, t, s, Centroid, corr, err, Model] = globalProcrustes(Model, tol, nStabilizationSteps, nMaxSteps)
%
% This is an implementation of the Iterative Closest Point (ICP) algorithm
% through Global Procustes Analisys.
% The function try to align the different views contained in the var Model.
%
% Arguments: Model - 1 x numberOfViews struct. Each substruct must contain:
%                       vertices - 3 x nPoints Array
%                       (weights) - 1 x NPoints array of weights associated
%                                  with each point
%           nMaxSteps - Number of maximum allowed steps for the algorithm
%
% Returns: R - Registred data rotation vectors
%          t - Registred data translation vectors
%          s - Registred data scale
%          Centroid - Centroids coordinates at each step.
%          corr - point Correspondances
%          Model - Transformed model


c2 = 1;
R = cell(length(Model),nMaxSteps);
t = cell(length(Model),nMaxSteps);
s = cell(length(Model),nMaxSteps);
step = 1;
stabilizationSteps = 0;

% Initialize models
modelHasWeights = true;

for i=1:length(Model)
   %fprintf(1,'.');
    nPtBeforeUnique = size(Model(i).vertices,1);
    [Model(i).vertices Idx] = unique(Model(i).vertices,'rows');
    if(~isfield(Model(i),'weights') || size(Model(i).weights,1) ~= nPtBeforeUnique || size(Model(i).weights,2) ~= 1)
        modelHasWeights = false;
    else
        Model(i).weights = Model(i).weights(Idx,:);
        Model(i).weights(isnan(Model(i).weights)) = 0.5;
        Model(i).weights(isinf(Model(i).weights)) = 0.5;
    end
end

if(modelHasWeights)
   %fprintf(1,'\nWeights have been found ');
end

%fprintf(1,'\nInitializing data(Computing Delaunay Triangulation) ');

for i=1:length(Model)
   %fprintf(1,'.');
    Model(i).tri = delaunayn([Model(i).vertices]);
end

Trans = [];
for i=1:length(Model)
   Trans(i).T =eye(4, 4);
end

while (step < nMaxSteps)

    
    numOfPoints = 0;
    
    %fprintf(1,'\n Step %d \n',step);
    
    c1 = c2;
    
    modelSpan = zeros(length(Model)+1,1);
    % reinitialize data struct
    for i=1:length(Model)
        % store the correspandances,
        % -- zeros instead of sparse to be memory efficient
        %Model(i).corrOM = zeros(length(Model(i).vertices),length(Model));
        %Model(i).corrCentr = zeros(length(Model(i).vertices),length(Model));
        %Model(i).corr = cell(length(Model),1);
        %Model(i).D = cell(length(Model),1);
        modelSpan(i) = numOfPoints;
        numOfPoints = numOfPoints + size(Model(i).vertices,1);
    end
    modelSpan(length(Model)+1) = numOfPoints;
    %fprintf(1,'Computing correspondances ');

    
    CentroidPtsBelMod = zeros(numOfPoints,length(Model),'int32');
    
    D = 0;
    countD = 0;
    %compute correspondances
     for i=1:length(Model)
        %fprintf(1,'.');
        spanI = modelSpan(i)+1:modelSpan(i+1); 
        CentroidPtsBelMod(spanI,i) = 1:length(spanI);

%         for j=mod(i,length(Model))+1:mod(i,length(Model))+1
          for j=i+1:length(Model)
            
            spanJ = modelSpan(j)+1:modelSpan(j+1); 
            % Pick only the correspondances that have the same neighboard
            % in both views

            %disp(sprintf('Span I for i=%d', i));
            %spanI
            
            %disp(sprintf('Span J for j = %d', j));
            %spanJ

            %disp(sprintf('i j %g %g', i, j));

            %Model(i).vertices
            %Model(j).vertices
            
            [Corr1, D1] = dsearchn(Model(j).vertices, Model(j).tri, Model(i).vertices);

            %disp(sprintf('model i %g', i))
            %Model(i).vertices

            %disp(sprintf('model j %g', j));
            %Model(j).vertices

            %disp(sprintf('corr1 is'));
            
            Corr1(:,2) = 1:length(Corr1);
%            Corr1(D1 > tol,:) = [];
            
            [Corr2, D2] = dsearchn(Model(i).vertices, Model(i).tri, Model(j).vertices);
            
            Corr2(:,2) = Corr2(:,1);
            Corr2(:,1) = 1:length(Corr2);
%            Corr2(D2 > tol,:) = [];

            %Corr1-1
            %Corr2-1
           
            funique = ismember(Corr1,Corr2,'rows');
            Corr = Corr1(funique,:);

            
            %Corr

            %disp(sprintf('spanI'));
            %[spanI(Corr(:,2))'  Corr(:,1)]'
            %[spanJ(Corr(:,1))'  Corr(:,2)]'
            
            %disp(sprintf('spanJ'));
            %spanJ(Corr(:,1))
            
            CentroidPtsBelMod(spanI(Corr(:,2)),j) = Corr(:,1)';
            CentroidPtsBelMod(spanJ(Corr(:,1)),i) = Corr(:,2)';

            %CentroidPtsBelMod'
            
            if(mod(i,length(Model))+1 == j)
               D = D + sum(sum((Model(i).vertices(Corr1(funique,2),:) - Model(j).vertices(Corr1(funique,1),:)).^2,2));
               countD = countD + length(funique);
            end
         end
    end

    %CentroidPtsBelMod'

    %sum(CentroidPtsBelMod>0,2) < 2

    %A = CentroidPtsBelMod;

    %size(CentroidPtsBelMod)

    %CentroidPtsBelMod
    
    CentroidPtsBelMod(sum(CentroidPtsBelMod>0,2)<2,:) = [];

    %B = CentroidPtsBelMod;

    %size(CentroidPtsBelMod)
    
    %CentroidPtsBelMod

    CentroidPtsBelMod = unique(CentroidPtsBelMod,'rows');

    %CentroidPtsBelMod
            
    %fprintf(1,' %d (all: %d) found\nUpdating Centroid ', size(CentroidPtsBelMod,1), numOfPoints );
    
    numOfPoints = size(CentroidPtsBelMod,1);

    % Compute the centroid
    Centroid = zeros(numOfPoints,3);
    
    for i=1:length(Model)
       %fprintf(1,'.');
        centroidIndex = find(CentroidPtsBelMod(:,i) > 0) ;
        toBeAdded = CentroidPtsBelMod(centroidIndex,i);
        Centroid(centroidIndex,:) = Centroid(centroidIndex,:) + Model(i).vertices(toBeAdded,:);
    end
    
    Centroid(:,1) = Centroid(:,1) ./ sum(CentroidPtsBelMod>0,2);
    Centroid(:,2) = Centroid(:,2) ./ sum(CentroidPtsBelMod>0,2);
    Centroid(:,3) = Centroid(:,3) ./ sum(CentroidPtsBelMod>0,2);
   
    %Centroid
    
    %fprintf(1,'\nComputing Transformations ');
    
    sqErr = 0;
    sqErrBefore = 0;
    val2  = 0;
    %disp(sprintf('\nDoing step: %d\n', step));
    
    
    % WGPA on all centroid points
    for i=1:length(Model)
       %fprintf(1,'.');
        inCentroid = find(CentroidPtsBelMod(:,i) > 0);
        modIdx = CentroidPtsBelMod(inCentroid,i);
        A = Model(i).vertices(modIdx,:);
        B = Centroid(inCentroid,:);
        
        tot = CentroidPtsBelMod(inCentroid,:);
        curweights = ones(length(inCentroid),length(Model));
        
        if(modelHasWeights)
            for j=1:length(Model)
                idx = find(tot(:,j)>0);
                curweights(idx,j) = Model(j).weights(tot(idx,j));
            end
            [R1, t1, s1] = reg(B', A', transOnly, 1.0 - 2*mad(curweights')');        
        else
            [R1, t1, s1] = reg(B', A', transOnly);  
        end

        sqErrBefore = sqErrBefore + sum(sum((Model(i).vertices(modIdx,:) - Centroid(inCentroid,:)).^2));

	
        
        Model(i).vertices = (R1*Model(i).vertices'*s1);
        Model(i).vertices = [Model(i).vertices(1,:)+t1(1); Model(i).vertices(2,:)+t1(2); Model(i).vertices(3,:)+t1(3)]';

        R{i,step} = R1;
        t{i,step} = t1;
        s{i,step} = s1;

        sqErr = sqErr + sum(sum((Model(i).vertices(modIdx,:) - Centroid(inCentroid,:)).^2));
        
        Trans0           = eye(4, 4);
        Trans0(1:3, 1:3) = R1;
        Trans0(1:3, 4)   = t1;
        
        Trans(i).T = Trans0*Trans(i).T;
        %disp(sprintf('transform for model %i: ', i));
        %Trans(i).T

    end

    disp(sprintf('before normalizing %g %g', sqErrBefore, sqErr));
    
    sqErr = sqErr/numOfPoints;

    disp(sprintf('num o fpoints %g', numOfPoints));
    sqErrBefore = sqErrBefore/numOfPoints;

    
    corr(step) = numOfPoints;
    fprintf(1,'Mean square error(on point correspondances) Before-After : %f %f\n',sqErrBefore,sqErr);

    %disp(sprintf('step is %g', step));
    step = step + 1;
    
end

% Get the transformation to A in B
function [R1, t1, s1] = reg(B, A, transOnly, w)

if nargin < 4
    n = size(B,2);
    mm = mean(B,2);
    ms = mean(A,2);
    Sshifted = [A(1,:)-ms(1); A(2,:)-ms(2); A(3,:)-ms(3)];
    Mshifted = [B(1,:)-mm(1); B(2,:)-mm(2); B(3,:)-mm(3)];
    K = Sshifted*Mshifted';
    K = K/n;
    [U d V] = svd(K);
    R1 = V*U';
    if det(R1)<0
        A = eye(3);
        A(3,3) = det(V*U');
        R1 = V*A*U';
    end

    if transOnly == 1
       R1 = eye(3, 3);
    end
    
    t1 = mm - R1*ms;
    s1 = 1;
else
    
    
    % memory saving procedure... but requires more time in matlab
    AjMul = zeros(size(A));
    for i = 1:size(A,2)
        %compute I - ((Jw * Jw^T) / (Jw^T * Jw))
        col = (-w(i) * w' ./ (w' * w));
        col(i) = col(i)+1;
        
        for j=1:size(A,1);
            AjMul(j,i) = A(j,:) * col';
        end        
    end
   
    [V D W] = svd(AjMul * B');
    
    R1 = W * V';
    s1 = trace(R1' * AjMul * B') / trace(AjMul * A');
    t1 = (B - R1*s1*A) * (w/(w' * w));
end
