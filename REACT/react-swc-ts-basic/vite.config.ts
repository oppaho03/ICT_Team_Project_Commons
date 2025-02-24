import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react-swc'
import { resolve } from 'path';

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  mode: "development", // development | production ( npm run build --mode __모드__ ) 
  resolve: {
    extensions: [ '.js', '.ts' ],
  },
  build: {
    outDir: 'dist/js',
    rollupOptions: {
      input: {
        app: resolve( __dirname, 'src/ts/app.ts' ), // EP. R
      },
      output: {
        entryFileNames: '[name].min.js',
        assetFileNames: '[mame].[ext]', // OUTPUT file namming 
      }
    }
  },
  server: {
    port: 9000,
    open: true,
    cors: true,
  }
})
