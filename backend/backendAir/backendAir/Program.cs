using backendAir;
using backendAir.Models;
using Microsoft.EntityFrameworkCore;
using System.Text.Json.Serialization;

var builder = WebApplication.CreateBuilder(args);

// ����������� � PostgreSQL
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql("Host=localhost;Port=5432;Database=air;Username=postgres;Password=1111"));

// ��������� ����������� � ���������� JSON ��� ��������� ����������� ������
builder.Services.AddControllers()
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles; // ������������� ������
        options.JsonSerializerOptions.DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull; // ������������ null-��������
    });

var app = builder.Build();

app.UseRouting();
app.UseCors(policy => policy.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod());

app.UseEndpoints(endpoints =>
{
    endpoints.MapControllers(); // ���������� �����������
});

app.Run("http://localhost:5000"); // ��������� �� ����� 5000