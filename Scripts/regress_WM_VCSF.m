% for all hemispheres, for all regions, for all subjects
% generate new time courses with WM and CSF regressed out

%hemispheres
hemis = ["lh"; "rh"];
n_h = size(hemis, 1);

%regions
regions = [ ...
"BA1_exvivo"; ...
"BA2_exvivo"; ...
"BA3a_exvivo"; ...
"BA3b_exvivo"; ...
"BA4a_exvivo"; ...
"BA4p_exvivo"; ...
"BA6_exvivo"; ...
"BA44_exvivo"; ...
"BA45_exvivo"; ...
"cortex"; ...
"entorhinal_exvivo"; ...
"MT_exvivo"; ...
"perirhinal_exvivo"; ...
"V1_exvivo"; ...
"V2_exvivo"; ...
];
n_r = size(regions, 1);

%subject functional files
subjects = [ ...
    "B101"; ...
    "B102"; ...
    "B103"; ...
    "B104"; ...
    "B105"; ...
    "B106"; ...
    "B107"; ...
    "B108"; ...
    "B109"; ...
    "B111"; ...
    "B112"; ...
    "S201"; ...
    "S203"; ...
    "S204"; ...
    "S205"; ...
    "S206"; ...
    "S207"; ...
    "S208"; ...
    "S209"; ...
    "S212"; ...
    "S213"; ...
    "S214"; ...
    "S215"; ...
    "S216"; ...
]; 
n_s = size(subjects,1);

for h = 1 : n_h
    hemi = hemis(h);
    for r = 1: n_r
        region = regions(r);
        for s = 1 : n_s
            subject = subjects(s);
            s_path = char(strcat( ...
                '/Users/caramazzalab/Desktop/Jess/V1_REST_STUDY/dicomdir/'...
                , subject, '/bold/001'));
            addpath(s_path);
            % Generate a timecourse for region
            file_str = strcat(hemi, ".", region, ".dat");
            TC = dlmread(char(file_str));
            % Generate a timecourse for wm
            wm = dlmread('wm.dat');
            wm = wm(:, 1:5);
            % Generate a timecourse for vcsf
            vcsf = dlmread('vcsf.dat');
            vcsf = vcsf(:, 1:5);
            
            % Find the residuals
            [b, bint, res] = regress(TC, [wm, vcsf]);

            %write the file
            new_file_str = strcat(hemi, ".", region, ".wmvscf.dat");
            new_filename = char(new_file_str);
            dlmwrite(new_filename, res);
            
            %move the file
            movefile(new_filename, s_path);
        end
    end
end