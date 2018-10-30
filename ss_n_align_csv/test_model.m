function test_model(nMaxSteps)
N=10;
%v = 1*rand(N, 3);

%format long g

%v

%v=sortrows(v);

%p=2;
%w = [v(1:(p-1), :)' v((p+1):N, :)']';

%w

%~/projects/StereoPipelineTest/ss_pc_align_fgr/ref.txt  ~/projects/StereoPipelineTest/ss_pc_align_fgr/src.txt

u=load('in/out-trans_cloud-0.csv');
v=load('in/out-trans_cloud-1.csv');
w=load('in/out-trans_cloud-2.csv');

u = round(u*1000)/1000
v = round(v*1000)/1000
w = round(w*1000)/1000

A=[];
B=[];
C=[];

%nMaxSteps = 11;

for transOnly=0:0

   A.vertices = u;
   B.vertices = v;
   C.vertices = w;
   %Model = [A, B];
   Model = [A, B, C];
   
   %for i = 2:length(Model)
   %   Model(i).vertices = Model(1).vertices + 7*i;
   %end

   %A.vertices
   %B.vertices
   
   %transOnly = 0;
   [R, t, s, Centroid, corr, Model, Trans] = globalProcrustes(Model, nMaxSteps, transOnly);

   format short g
   for it=2:length(Model)
      inv(Trans(1).T)*(Trans(it).T)
   end

   for i=1:length(Model)
      for j=1:nMaxSteps
         %disp(sprintf('transform for model %d', i));
         %R{i, j}
         %t{i, j}
      end
   end

end
