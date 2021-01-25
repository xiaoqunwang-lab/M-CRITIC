clear;

dir_path = 'Raw';
folder = dir(dir_path);
xyz_corr = importdata('Raw\comments.xlsx');
folder_n = size(xyz_corr.textdata,1);
x0 = inf;
x1 = -inf;
y0 = inf;
y1 = -inf;
z0 = inf;
z1 = -inf;
xx_c = 1574;
yy_c = 446;
zz_c = 344;

figure;
hold on;
for i = 1:folder_n
    temp_path = [dir_path,'\',xyz_corr.textdata{i}];
    flip_corr = 0;
    myColor = [0,0.4470,0.7410];

    if strcmp(xyz_corr.textdata{i},'2-9 dendrites SWC') == 1
        myColor = [0.6350,0.0780,0.1840];
    end;
 
    file_list = dir(temp_path);
    file_n = size(file_list,1);
    x_corr = xyz_corr.data(i,1);
    y_corr = xyz_corr.data(i,2);
    z_corr = xyz_corr.data(i,3);
    
    for j =1:file_n-2
        [i,j]
        file_path = [temp_path,'\',file_list(j).name];
        temp_s = importdata(file_path,' ',6);
        x3d = temp_s.data(:,3) + x_corr;
        y3d = temp_s.data(:,4) + y_corr;
        if flip_corr>0
            z3d = -temp_s.data(:,5) + flip_corr + z_corr;
        else
            z3d = temp_s.data(:,5) + z_corr;        
        end;
            
        % smooth curve
        x3d = smooth(x3d)-xx_c;
        y3d = smooth(y3d)-yy_c;
        z3d = smooth(z3d)-zz_c;
                
        xyz_len = size(x3d,1);
        x_p = ones(xyz_len,1)*(1100);
        y_p = ones(xyz_len,1)*(-1600);
        z_p = ones(xyz_len,1)*(-500);

        temp = y3d;
        y3d = z3d;
        z3d = temp;
                       
        plot3(x3d,y3d,z3d,'color',myColor);
        x0 = min(x0,min(x3d));
        x1 = max(x1,max(x3d));
        y0 = min(y0,min(y3d));
        y1 = max(y1,max(y3d));
        z0 = min(z0,min(z3d));
        z1 = max(z1,max(z3d));
                
    end;
end;

fn = 'patches.xlsx';
ps = xlsread(fn);
ps_n = size(ps,1);
for i = 1:2:ps_n
       
    xx = [ps(i,1),ps(i+1,1)];
    yy = [ps(i,2),ps(i+1,2)];
    zz = [ps(i,3),ps(i+1,3)];
      
    % patch color
    if ps(i,4)==1
        myColor = [0.7,0.7,0.3];
    else
        myColor = [0.6350,0.0780,0.1840];
    end;
    plot3(xx,yy,zz,'color',myColor);
    
    xyz_len = size(xx,1);
    x_p = [1100,1100];
    y_p = [-1600,-1600];
    z_p = [-500,-500];
end;
[x,y,z]=ellipsoid(1035-xx_c,50-zz_c,1540-yy_c,7.5,4.8,5,100);
surf(x,y,z,'linestyle','none','facecolor',[0.85,0.325,0.098]);
hold off;

view([-135,15])
daspect([1 1 1])
x_center = (x0+x1)/2;
y_center = (y0+y1)/2;
z_center = (z0+z1)/2;
[x_center,y_center,z_center]

xlabel('L-R (X)');
ylabel('A-P (Y)');
zlabel('V-D (Z)');
axis([-7184.96,4456.22,-4812.86,8637.86,-4784.49,3489.06]);
set(gca,'ydir','reverse');
