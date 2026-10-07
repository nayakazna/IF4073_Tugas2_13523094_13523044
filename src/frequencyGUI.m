function frequencyGUI()
% iki GUI-ne ws dadi, nnti pls isi fungsi H(u,v) di tab B-F (masi stub, ntar cek TODO ae yah).

    BG_FIG   = [0.11 0.11 0.12];
    BG_PANEL = [0.16 0.16 0.18];
    BG_CTRL  = [0.22 0.22 0.24];
    BG_AXES  = [0.09 0.09 0.10];
    FG_TEXT  = [0.90 0.90 0.92];
    GRID_COL = [0.55 0.55 0.58];

    originalImg = [];
    refImg = [];
    isColor = false;
    sourceFile = '';
    % hasil terakhir tiap tab, buat Save Result
    results = struct('B', {{}}, 'C', {{}}, 'D', {{}}, 'E', {{}}, 'F', {{}});
    tabKeys = {'B', 'C', 'D', 'E', 'F'};

    fig = figure('Name', 'Pemrosesan Citra Ranah Frekuensi', ...
        'NumberTitle', 'off', 'MenuBar', 'none', 'ToolBar', 'none', ...
        'Units', 'normalized', 'Position', [0.03 0.05 0.94 0.88], ...
        'Color', BG_FIG);

    mkButton(fig, 'Load Image', [0.01 0.945 0.10 0.045], BG_CTRL, FG_TEXT, @loadImageCallback);
    mkButton(fig, 'Load Reference', [0.12 0.945 0.12 0.045], BG_CTRL, FG_TEXT, @loadRefCallback);
    mkButton(fig, 'Save Result', [0.88 0.945 0.11 0.045], BG_CTRL, FG_TEXT, @saveResultCallback);
    fileNameText = mkLabel(fig, 'Belum ada citra dimuat', [0.26 0.945 0.60 0.04], false, BG_FIG, FG_TEXT);

    tg = uitabgroup(fig, 'Units', 'normalized', 'Position', [0.01 0.11 0.98 0.83]);
    tabB = uitab(tg, 'Title', 'B. Smoothing (LPF)');
    tabC = uitab(tg, 'Title', 'C. High-Pass (HPF)');
    tabD = uitab(tg, 'Title', 'D. Kecerahan');
    tabE = uitab(tg, 'Title', 'E. Derau Periodik');
    tabF = uitab(tg, 'Title', 'F. Motion Blur');
    for t = [tabB, tabC, tabD, tabE, tabF]
        try, t.BackgroundColor = BG_PANEL; catch, end
    end

    logText = uicontrol(fig, 'Style', 'edit', 'Max', 2, 'Min', 0, ...
        'Units', 'normalized', 'Position', [0.01 0.01 0.98 0.085], ...
        'HorizontalAlignment', 'left', 'Enable', 'inactive', 'FontName', 'FixedWidth', ...
        'BackgroundColor', BG_CTRL, 'ForegroundColor', FG_TEXT, ...
        'String', {'Muat citra dlu, trus pilih tab dan pencet Apply.'});

    ctrlPos = [0.01 0.77 0.98 0.22];
    gridPos = [0.01 0.01 0.98 0.75];
    passTypes = {'Ideal', 'Gaussian', 'Butterworth'};

    % tab B
    pB = mkPanel(tabB, ctrlPos, BG_PANEL, FG_TEXT, 'Parameter Low-Pass Filter');
    mkLabel(pB, 'Jenis:', [0.01 0.52 0.06 0.30], false, BG_PANEL, FG_TEXT);
    ddB = mkPopup(pB, {'Ideal (ILPF)', 'Gaussian (GLPF)', 'Butterworth (BLPF)'}, [0.07 0.52 0.16 0.30], BG_CTRL, FG_TEXT, @(~,~) toggleOrderB());
    mkLabel(pB, 'D0:', [0.25 0.52 0.04 0.30], false, BG_PANEL, FG_TEXT);
    edD0B = mkEdit(pB, '30', [0.29 0.52 0.07 0.30], BG_CTRL, FG_TEXT);
    lblNB = mkLabel(pB, 'orde n:', [0.38 0.52 0.07 0.30], false, BG_PANEL, FG_TEXT);
    edNB = mkEdit(pB, '2', [0.45 0.52 0.06 0.30], BG_CTRL, FG_TEXT);
    toggleOrderB();
    mkButton(pB, 'Apply', [0.01 0.10 0.14 0.32], BG_CTRL, FG_TEXT, @(~,~) runPass('B'));
    infoB = mkTextBox(pB, [0.64 0.05 0.35 0.90], BG_CTRL, FG_TEXT);
    axB = mkAxesGrid(tabB, {'Citra Masukan', 'Spektrum Masukan', 'Fungsi Penapis H(u,v)', ...
        'Spektrum Setelah Penapisan', 'Citra Hasil', 'Citra Referensi'}, gridPos, BG_AXES, GRID_COL, FG_TEXT);

    % tab C
    pC = mkPanel(tabC, ctrlPos, BG_PANEL, FG_TEXT, 'Parameter High-Pass Filter');
    mkLabel(pC, 'Jenis:', [0.01 0.52 0.06 0.30], false, BG_PANEL, FG_TEXT);
    ddC = mkPopup(pC, {'Ideal (IHPF)', 'Gaussian (GHPF)', 'Butterworth (BHPF)'}, [0.07 0.52 0.16 0.30], BG_CTRL, FG_TEXT, @(~,~) toggleOrderC());
    mkLabel(pC, 'D0:', [0.25 0.52 0.04 0.30], false, BG_PANEL, FG_TEXT);
    edD0C = mkEdit(pC, '30', [0.29 0.52 0.07 0.30], BG_CTRL, FG_TEXT);
    lblNC = mkLabel(pC, 'orde n:', [0.38 0.52 0.07 0.30], false, BG_PANEL, FG_TEXT);
    edNC = mkEdit(pC, '2', [0.45 0.52 0.06 0.30], BG_CTRL, FG_TEXT);
    toggleOrderC();
    mkButton(pC, 'Apply', [0.01 0.10 0.14 0.32], BG_CTRL, FG_TEXT, @(~,~) runPass('C'));
    infoC = mkTextBox(pC, [0.64 0.05 0.35 0.90], BG_CTRL, FG_TEXT);
    axC = mkAxesGrid(tabC, {'Citra Masukan', 'Spektrum Masukan', 'Fungsi Penapis H(u,v)', ...
        'Spektrum Setelah Penapisan', 'Citra Hasil', 'Citra Referensi'}, gridPos, BG_AXES, GRID_COL, FG_TEXT);

    % tab D
    pD = mkPanel(tabD, ctrlPos, BG_PANEL, FG_TEXT, 'Parameter Peningkatan Kecerahan');
    mkLabel(pD, 'gain:', [0.01 0.52 0.05 0.30], false, BG_PANEL, FG_TEXT);
    edGainD = mkEdit(pD, '1.5', [0.06 0.52 0.07 0.30], BG_CTRL, FG_TEXT);
    mkLabel(pD, 'D0:', [0.15 0.52 0.04 0.30], false, BG_PANEL, FG_TEXT);
    edD0D = mkEdit(pD, '30', [0.19 0.52 0.07 0.30], BG_CTRL, FG_TEXT);
    mkButton(pD, 'Apply', [0.01 0.10 0.14 0.32], BG_CTRL, FG_TEXT, @(~,~) runBrightness());
    infoD = mkTextBox(pD, [0.64 0.05 0.35 0.90], BG_CTRL, FG_TEXT);
    axD = mkAxesGrid(tabD, {'Citra Masukan', 'Spektrum Masukan', 'Fungsi Penapis H(u,v)', ...
        'Spektrum Setelah Penapisan', 'Citra Hasil', 'Citra Referensi'}, gridPos, BG_AXES, GRID_COL, FG_TEXT);

    % tab E (spike-nya diklik aja)
    pE = mkPanel(tabE, ctrlPos, BG_PANEL, FG_TEXT, 'Parameter Restorasi Derau Periodik');
    mkLabel(pE, 'Penapis:', [0.01 0.52 0.07 0.30], false, BG_PANEL, FG_TEXT);
    ddE = mkPopup(pE, {'Bandreject Ideal', 'Bandreject Gaussian', 'Bandreject Butterworth', 'Notch Reject'}, ...
        [0.08 0.52 0.17 0.30], BG_CTRL, FG_TEXT, @(~,~) toggleNotchInputs());
    lblD0E = mkLabel(pE, 'D0:', [0.27 0.52 0.04 0.30], false, BG_PANEL, FG_TEXT);
    edD0E = mkEdit(pE, '60', [0.31 0.52 0.06 0.30], BG_CTRL, FG_TEXT);
    lblWE = mkLabel(pE, 'W:', [0.39 0.52 0.03 0.30], false, BG_PANEL, FG_TEXT);
    edWE = mkEdit(pE, '10', [0.42 0.52 0.06 0.30], BG_CTRL, FG_TEXT);
    lblRE = mkLabel(pE, 'radius:', [0.27 0.52 0.06 0.30], false, BG_PANEL, FG_TEXT);
    edRE = mkEdit(pE, '10', [0.33 0.52 0.06 0.30], BG_CTRL, FG_TEXT);
    lblNE = mkLabel(pE, 'orde n:', [0.50 0.52 0.06 0.30], false, BG_PANEL, FG_TEXT);
    edNE = mkEdit(pE, '2', [0.56 0.52 0.05 0.30], BG_CTRL, FG_TEXT);
    lblNotchE = mkLabel(pE, 'notch du,dv; ...:', [0.01 0.12 0.11 0.30], false, BG_PANEL, FG_TEXT);
    edNotchE = mkEdit(pE, '', [0.12 0.12 0.30 0.30], BG_CTRL, FG_TEXT);
    btnPickE = mkButton(pE, 'Pick dari Spektrum', [0.43 0.12 0.14 0.32], BG_CTRL, FG_TEXT, @(~,~) pickNotch());
    mkButton(pE, 'Apply', [0.58 0.12 0.05 0.32], BG_CTRL, FG_TEXT, @(~,~) runPeriodic());
    toggleNotchInputs();
    infoE = mkTextBox(pE, [0.64 0.05 0.35 0.90], BG_CTRL, FG_TEXT);
    axE = mkAxesGrid(tabE, {'Citra Terdegradasi', 'Spektrum Sebelum Restorasi', 'Mask / Penapis H(u,v)', ...
        'Spektrum Setelah Penapisan', 'Citra Hasil Restorasi', 'Citra Referensi'}, gridPos, BG_AXES, GRID_COL, FG_TEXT);

    % tab F
    pF = mkPanel(tabF, ctrlPos, BG_PANEL, FG_TEXT, 'Parameter Restorasi Motion Blur');
    mkLabel(pF, 'Panjang L:', [0.01 0.52 0.08 0.30], false, BG_PANEL, FG_TEXT);
    edLenF = mkEdit(pF, '15', [0.09 0.52 0.06 0.30], BG_CTRL, FG_TEXT);
    mkLabel(pF, 'Sudut (deg):', [0.17 0.52 0.09 0.30], false, BG_PANEL, FG_TEXT);
    edAngF = mkEdit(pF, '0', [0.26 0.52 0.06 0.30], BG_CTRL, FG_TEXT);
    mkLabel(pF, 'Inverse: radius:', [0.01 0.12 0.11 0.30], false, BG_PANEL, FG_TEXT);
    edRadF = mkEdit(pF, 'Inf', [0.12 0.12 0.06 0.30], BG_CTRL, FG_TEXT);
    mkLabel(pF, 'min|H|:', [0.20 0.12 0.06 0.30], false, BG_PANEL, FG_TEXT);
    edMinHF = mkEdit(pF, '0.001', [0.26 0.12 0.06 0.30], BG_CTRL, FG_TEXT);
    mkLabel(pF, 'Wiener K:', [0.34 0.12 0.08 0.30], false, BG_PANEL, FG_TEXT);
    edKF = mkEdit(pF, '0.01', [0.42 0.12 0.06 0.30], BG_CTRL, FG_TEXT);
    mkButton(pF, 'Apply', [0.50 0.12 0.12 0.32], BG_CTRL, FG_TEXT, @(~,~) runMotionBlur());
    infoF = mkTextBox(pF, [0.64 0.05 0.35 0.90], BG_CTRL, FG_TEXT);
    axF = mkAxesGrid(tabF, {'Citra Asli / Referensi', 'Citra Terdegradasi', 'PSF', '|H(u,v)|', ...
        'Spektrum Terdegradasi', 'Hasil Inverse Filtering', 'Hasil Wiener Filtering'}, gridPos, BG_AXES, GRID_COL, FG_TEXT);

    % load/save
    function loadImageCallback(~, ~)
        [f, p] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp;*.tif;*.tiff', 'Image Files'});
        if isequal(f, 0), return; end
        raw = imread(fullfile(p, f));
        if ndims(raw) == 3 && size(raw, 3) >= 3
            rawRgb = raw(:, :, 1:3);
            isColor = ~(isequal(rawRgb(:, :, 1), rawRgb(:, :, 2)) && isequal(rawRgb(:, :, 2), rawRgb(:, :, 3)));
            if isColor
                originalImg = double(rawRgb);
            else
                originalImg = double(rawRgb(:, :, 1));
            end
        else
            originalImg = double(raw(:, :, 1));
            isColor = false;
        end
        sourceFile = f;
        results = struct('B', {{}}, 'C', {{}}, 'D', {{}}, 'E', {{}}, 'F', {{}});
        set(fileNameText, 'String', f);
        refreshInputs();
        setLog(sprintf('Citra dimuat: %s (%d x %d, %s)', f, size(originalImg, 1), size(originalImg, 2), ...
            ternary(isColor, 'berwarna', 'grayscale')));
    end

    function loadRefCallback(~, ~)
        [f, p] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp;*.tif;*.tiff', 'Image Files'});
        if isequal(f, 0), return; end
        raw = imread(fullfile(p, f));
        refImg = double(raw);
        if ndims(refImg) == 3, refImg = refImg(:, :, 1:3); end
        refreshInputs();
        setLog(sprintf('Referensi dimuat: %s', f));
    end

    function saveResultCallback(~, ~)
        key = tabKeys{find([tabB tabC tabD tabE tabF] == tg.SelectedTab, 1)};
        out = results.(key);
        if isempty(out)
            warndlg('Belum ada hasil pada tab ini. Tekan Apply dulu.'); return;
        end
        [baseName, ~, ~] = fileparts(sourceFile);
        for k = 1:size(out, 1)
            suffix = out{k, 1};
            [f, p] = uiputfile({'*.png', 'PNG Image (*.png)'; '*.jpg', 'JPEG Image (*.jpg)'}, ...
                'Simpan Citra Hasil', sprintf('%s_%s%s.png', baseName, key, suffix));
            if isequal(f, 0), continue; end
            imwrite(uint8(out{k, 2}), fullfile(p, f));
            setLog(sprintf('Citra hasil disimpan: %s', f));
        end
    end

    % tombol Apply tiap tab
    function runPass(key)
        if ~checkInputLoaded(), return; end
        try
            if key == 'B'
                dd = ddB; edD0 = edD0B; edN = edNB; ax = axB; info = infoB; builder = @lowPassFilter;
            else
                dd = ddC; edD0 = edD0C; edN = edNC; ax = axC; info = infoC; builder = @highPassFilter;
            end
            type = passTypes{get(dd, 'Value')};
            D0 = getNum(edD0, 'D0', 0);
            n = getNum(edN, 'orde n', 1);
            [M, N, ~] = size(originalImg);
            H = builder(M, N, type, D0, n);
            [result, specAfter] = filterImage(H);
            showMat(ax{3}, H, [0 max(1, max(H(:)))], 'Fungsi Penapis H(u,v)');
            showMat(ax{4}, logSpectrum(specAfter), [], 'Spektrum Setelah Penapisan');
            showImg(ax{5}, result, 'Citra Hasil');
            results.(key) = {'', result};
            set(info, 'String', {sprintf('Jenis: %s', type), sprintf('D0: %.4g', D0), ...
                ternary(strcmp(type, 'Butterworth'), sprintf('Orde n: %d', n), 'Orde n: -'), ...
                sprintf('Ukuran: %d x %d', M, N)});
            setLog(sprintf('Selesai: %s (D0=%.4g)', type, D0));
        catch ME
            reportError(ME);
        end
    end

    function runBrightness()
        if ~checkInputLoaded(), return; end
        try
            gain = getNum(edGainD, 'gain', 0);
            D0 = getNum(edD0D, 'D0', 0);
            [M, N, ~] = size(originalImg);
            H = brightnessFilter(M, N, gain, D0);
            [result, specAfter] = filterImage(H);
            showMat(axD{3}, H, [0 max(1, max(H(:)))], 'Fungsi Penapis H(u,v)');
            showMat(axD{4}, logSpectrum(specAfter), [], 'Spektrum Setelah Penapisan');
            showImg(axD{5}, result, 'Citra Hasil');
            results.D = {'', result};
            set(infoD, 'String', {sprintf('gain: %.4g', gain), sprintf('D0: %.4g', D0), ...
                sprintf('Mean sebelum: %.2f', mean(grayOf(originalImg), 'all')), ...
                sprintf('Mean sesudah: %.2f', mean(grayOf(min(255, max(0, result))), 'all'))});
            setLog('Selesai: peningkatan kecerahan');
        catch ME
            reportError(ME);
        end
    end

    function runPeriodic()
        if ~checkInputLoaded(), return; end
        try
            choice = get(ddE, 'Value');
            names = get(ddE, 'String');
            [M, N, ~] = size(originalImg);
            if choice == 4
                notches = parseNotches(get(edNotchE, 'String'));
                radius = getNum(edRE, 'radius', 0);
                n = getNum(edNE, 'orde n', 1);
                H = notchRejectFilter(M, N, notches, radius, n);
                desc = {sprintf('Notch: %s', mat2str(notches)), sprintf('radius: %.4g', radius), sprintf('orde n: %d', n)};
            else
                D0 = getNum(edD0E, 'D0', 0);
                W = getNum(edWE, 'W', 0);
                n = getNum(edNE, 'orde n', 1);
                H = bandRejectFilter(M, N, passTypes{choice}, D0, W, n);
                desc = {sprintf('D0: %.4g', D0), sprintf('W: %.4g', W), sprintf('orde n: %d', n)};
            end
            [result, specAfter] = filterImage(H);
            showMat(axE{3}, H, [0 1], 'Mask / Penapis H(u,v)');
            showMat(axE{4}, logSpectrum(specAfter), [], 'Spektrum Setelah Penapisan');
            showImg(axE{5}, result, 'Citra Hasil Restorasi');
            results.E = {'', result};
            set(infoE, 'String', [{sprintf('Penapis: %s', names{choice})}, desc]);
            setLog(sprintf('Selesai: %s', names{choice}));
        catch ME
            reportError(ME);
        end
    end

    function runMotionBlur()
        if ~checkInputLoaded(), return; end
        try
            len = getNum(edLenF, 'panjang L', 0);
            theta = getNum(edAngF, 'sudut', -Inf);
            radius = getNum(edRadF, 'radius', 0);
            minH = getNum(edMinHF, 'min|H|', 0);
            K = getNum(edKF, 'K', 0);
            [M, N, ~] = size(originalImg);
            psf = motionBlurPSF(len, theta);
            H = fftshift(psf2otf_(psf, M, N));
            showMat(axF{3}, psf, [], 'PSF');
            showMat(axF{4}, abs(H), [], '|H(u,v)|');

            nCh = ternary(isColor, 3, 1);
            inv = zeros(size(originalImg));
            wie = zeros(size(originalImg));
            for k = 1:nCh
                G = fftshift(fft2(originalImg(:, :, k)));
                inv(:, :, k) = real(ifft2(ifftshift(inverseFilter(G, H, radius, minH))));
                wie(:, :, k) = real(ifft2(ifftshift(wienerFilter(G, H, K))));
            end
            showImg(axF{6}, inv, 'Hasil Inverse Filtering');
            showImg(axF{7}, wie, 'Hasil Wiener Filtering');
            results.F = {'_inverse', clip(inv); '_wiener', clip(wie)};
            set(infoF, 'String', {sprintf('PSF: L=%.4g, sudut=%.4g deg', len, theta), ...
                sprintf('Inverse: radius=%.4g, min|H|=%.4g', radius, minH), ...
                sprintf('Wiener: K=%.4g', K)});
            setLog('Selesai: inverse & Wiener filtering');
        catch ME
            reportError(ME);
        end
    end

    % helper (males misahin file)
    function [result, specAfter] = filterImage(H)
        % H dikali per kanal RGB, spektrum 'sesudah' diambil dari versi gray aja
        result = applyPerChannel(originalImg, isColor, @(ch) applyFreqFilter(ch, H));
        [~, ~, specAfter] = applyFreqFilter(grayOf(originalImg), H);
    end

    function refreshInputs()
        if isempty(originalImg), return; end
        specIn = logSpectrum(fftshift(fft2(grayOf(originalImg))));
        for pair = {{axB, 'Citra Masukan'}, {axC, 'Citra Masukan'}, {axD, 'Citra Masukan'}, {axE, 'Citra Terdegradasi'}}
            ax = pair{1}{1};
            showImg(ax{1}, originalImg, pair{1}{2});
            showMat(ax{2}, specIn, [], 'Spektrum Masukan');
            if ~isempty(refImg), showImg(ax{6}, refImg, 'Citra Referensi'); end
        end
        showImg(axF{2}, originalImg, 'Citra Terdegradasi');
        showMat(axF{5}, specIn, [], 'Spektrum Terdegradasi');
        if ~isempty(refImg), showImg(axF{1}, refImg, 'Citra Asli / Referensi'); end
    end

    function showImg(ax, img, ttl)
        imshow(uint8(clip(img)), 'Parent', ax);
        title(ax, ttl, 'Color', FG_TEXT, 'FontSize', 9, 'Interpreter', 'none');
    end

    function showMat(ax, M, lims, ttl)
        if isempty(lims)
            lims = [min(M(:)), max(M(:))];
            if lims(2) <= lims(1), lims(2) = lims(1) + 1; end
        end
        imshow(M, lims, 'Parent', ax);
        title(ax, ttl, 'Color', FG_TEXT, 'FontSize', 9, 'Interpreter', 'none');
    end

    function g = grayOf(img)
        if size(img, 3) == 3, g = rgb2gray(img); else, g = img; end
    end

    function out = clip(img)
        out = max(0, min(255, img));
    end

    function toggleOrderB()
        toggleOrder(ddB, lblNB, edNB);
    end

    function toggleOrderC()
        toggleOrder(ddC, lblNC, edNC);
    end

    function toggleOrder(dd, lbl, ed)
        vis = ternary(get(dd, 'Value') == 3, 'on', 'off');
        set(lbl, 'Visible', vis); set(ed, 'Visible', vis);
    end

    function toggleNotchInputs()
        isNotch = get(ddE, 'Value') == 4;
        isBand = ~isNotch;
        onOff = @(b) ternary(b, 'on', 'off');
        set([lblD0E edD0E lblWE edWE], 'Visible', onOff(isBand));
        set([lblRE edRE lblNotchE edNotchE btnPickE], 'Visible', onOff(isNotch));
        set([lblNE edNE], 'Visible', onOff(isNotch || get(ddE, 'Value') == 3));
    end

    function pickNotch()
        if ~checkInputLoaded(), return; end
        [M, N, ~] = size(originalImg);
        setLog('Klik satu titik spike pada "Spektrum Sebelum Restorasi"...');
        axes(axE{2});
        [x, y] = ginput(1);
        if isempty(x), return; end
        du = round(y) - (floor(M/2) + 1);
        dv = round(x) - (floor(N/2) + 1);
        cur = strtrim(get(edNotchE, 'String'));
        if ~isempty(cur), cur = [cur '; ']; end
        set(edNotchE, 'String', sprintf('%s%d,%d', cur, du, dv));
        setLog(sprintf('Notch ditambahkan: du=%d, dv=%d', du, dv));
    end

    function notches = parseNotches(str)
        notches = str2num(['[' str ']']); %#ok<ST2NM>
        if isempty(notches) || size(notches, 2) ~= 2
            error('Format notch: "du,dv; du,dv" (offset baris,kolom dari pusat spektrum).');
        end
    end

    function v = getNum(h, name, minVal)
        v = str2double(get(h, 'String'));
        if isnan(v) || v < minVal
            error('Parameter %s tidak valid (harus angka >= %g).', name, minVal);
        end
    end

    function ok = checkInputLoaded()
        ok = ~isempty(originalImg);
        if ~ok, warndlg('Muat citra masukan dulu.'); end
    end

    function reportError(ME)
        if strcmp(ME.identifier, 'IF4073:notImplemented')
            setLog(['[TODO] ' ME.message]);
        else
            errordlg(ME.message, 'Gagal memproses');
            setLog(['Error: ' ME.message]);
        end
    end

    function setLog(msg)
        set(logText, 'String', {msg});
    end

    function out = ternary(cond, a, b)
        if cond, out = a; else, out = b; end
    end

end
