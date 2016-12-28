using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(QLNhaHang.Startup))]
namespace QLNhaHang
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
