--Câu 3: Liệt kê những dòng xe có số chỗ ngồi trên 5 chỗ
SELECT *
FROM dbo.DONGXE
WHERE SoChoNgoi > 5;
GO

--Câu 4: Liệt kê thông tin của các nhà cung cấp đã từng đăng ký cung cấp những dòng xe
--thuộc hãng xe “Toyota” với mức phí có đơn giá là 15.000 VNĐ/km hoặc những dòng xe
--thuộc hãng xe “KIA” với mức phí có đơn giá là 20.000 VNĐ/km
SELECT DISTINCT
       ncc.MaNhaCC,
       ncc.TenNhaCC,
       ncc.DiaChi,
       ncc.SoDT,
       ncc.MaSoThue
FROM dbo.NHACUNGCAP ncc
    INNER JOIN dbo.DANGKYCUNGCAP dk
        ON dk.MaNhaCC = ncc.MaNhaCC
    INNER JOIN dbo.DONGXE dx
        ON dx.DongXe = dk.DongXe
    INNER JOIN dbo.MUCPHI mp
        ON mp.MaMP = dk.MaMP
WHERE (
          dx.HangXe = 'Toyota'
          AND mp.DonGia = 15000
      )
      OR
      (
          dx.HangXe = 'KIA'
          AND mp.DonGia = 20000
      );
GO

--Câu 5: Liệt kê thông tin toàn bộ nhà cung cấp được sắp xếp tăng dần theo tên nhà cung
--cấp và giảm dần theo mã số thuế
SELECT ncc.MaNhaCC,
       ncc.TenNhaCC,
       ncc.DiaChi,
       ncc.SoDT,
       ncc.MaSoThue
FROM dbo.NHACUNGCAP ncc
ORDER BY ncc.TenNhaCC DESC,
         ncc.MaSoThue ASC;
GO

--Câu 6: Đếm số lần đăng ký cung cấp phương tiện tương ứng cho từng nhà cung cấp với
--yêu cầu chỉ đếm cho những nhà cung cấp thực hiện đăng ký cung cấp có ngày bắt đầu
--cung cấp là “20/11/2015”
SELECT ncc.MaNhaCC,
       ncc.TenNhaCC,
       ncc.DiaChi,
       ncc.SoDT,
       ncc.MaSoThue,
	   COUNT(MaDKCC) SoLanDangKi
FROM dbo.DANGKYCUNGCAP dk
INNER JOIN dbo.NHACUNGCAP ncc ON ncc.MaNhaCC = dk.MaNhaCC
WHERE CONVERT(DATE, dk.NgayBatDauCungCap) = CONVERT(DATE, '2015-11-20')
GROUP BY ncc.MaNhaCC,
       ncc.TenNhaCC,
       ncc.DiaChi,
       ncc.SoDT,
       ncc.MaSoThue;
GO

--Câu 7: Liệt kê tên của toàn bộ các hãng xe có trong cơ sở dữ liệu với yêu cầu mỗi hãng xe
--chỉ được liệt kê một lần
SELECT HangXe
FROM dbo.DONGXE
GROUP BY HangXe;
GO

--Câu 8: Liệt kê MaDKCC, MaNhaCC, TenNhaCC, DiaChi, MaSoThue, TenLoaiDV, DonGia,
--HangXe, NgayBatDauCC, NgayKetThucCC của tất cả các lần đăng ký cung cấp phương
--tiện với yêu cầu những nhà cung cấp nào chưa từng thực hiện đăng ký cung cấp phương
--tiện thì cũng liệt kê thông tin những nhà cung cấp đó ra
SELECT DISTINCT
       dk.MaDKCC,
       dk.MaNhaCC,
       ncc.TenNhaCC,
       ncc.DiaChi,
       ncc.MaSoThue,
       ldv.TenLoaiDV,
       mp.DonGia,
       dx.HangXe,
       dk.NgayBatDauCungCap,
       dk.NgayKetThucCungCap
FROM dbo.DANGKYCUNGCAP dk
    INNER JOIN dbo.NHACUNGCAP ncc
        ON ncc.MaNhaCC = dk.MaNhaCC
    INNER JOIN dbo.LOAIDICHVU ldv
        ON ldv.MaLoaiDV = dk.MaLoaiDV
    INNER JOIN dbo.MUCPHI mp
        ON mp.MaMP = dk.MaMP
    INNER JOIN dbo.DONGXE dx
        ON dx.DongXe = dk.DongXe;
GO

--Câu 9: Liệt kê thông tin của các nhà cung cấp đã từng đăng ký cung cấp phương tiện
--thuộc dòng xe “Hiace” hoặc từng đăng ký cung cấp phương tiện thuộc dòng xe “Cerato”
SELECT DISTINCT
       ncc.MaNhaCC,
       ncc.TenNhaCC,
       ncc.DiaChi,
       ncc.SoDT,
       ncc.MaSoThue
FROM dbo.NHACUNGCAP ncc
    INNER JOIN dbo.DANGKYCUNGCAP dk
        ON dk.MaNhaCC = ncc.MaNhaCC
WHERE (dk.DongXe = 'Hiace')
      OR (dk.DongXe = 'Cerato');
GO

--Câu 10: Liệt kê thông tin của các nhà cung cấp chưa từng thực hiện đăng ký cung cấp
--phương tiện lần nào cả

SELECT NCC.MaNhaCC,
       NCC.TenNhaCC
FROM NHACUNGCAP NCC
WHERE NOT EXISTS
(
    SELECT * FROM DANGKYCUNGCAP DK WHERE NCC.MaNhaCC = DK.MaNhaCC
);
-- => dùng EXISTS khi nó trả về 1 thứ gì đó ở sub query, ngược lại với not exists, dùng khi truy vấn con không trả về thứ gì.



