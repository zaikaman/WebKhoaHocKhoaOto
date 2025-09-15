
'use client';

import { useEffect, useRef } from 'react';
import { usePathname, useSearchParams } from 'next/navigation';
import NProgress from 'nprogress';

export function NextNProgress({
  color = '#29d',
  height = 3,
  options,
  showOnShallow = false,
}: {
  color?: string;
  height?: number;
  options?: Partial<NProgress.NProgressOptions>;
  showOnShallow?: boolean;
}) {
  const pathname = usePathname();
  const searchParams = useSearchParams();

  useEffect(() => {
    NProgress.configure({ showSpinner: false, ...options });
  }, [options]);

  useEffect(() => {
    const handleStart = () => NProgress.start();
    const handleStop = () => NProgress.done();

    // We listen to our own custom events dispatched from the layout.
    // This is to avoid issues with the Next.js router events not always firing.
    document.addEventListener('routeChangeStart', handleStart);
    document.addEventListener('routeChangeComplete', handleStop);
    document.addEventListener('routeChangeError', handleStop);

    return () => {
      document.removeEventListener('routeChangeStart', handleStart);
      document.removeEventListener('routeChangeComplete', handleStop);
      document.removeEventListener('routeChangeError', handleStop);
    };
  }, []);

  useEffect(() => {
    // This effect is just to ensure that the progress bar is removed on mount/unmount.
    return () => {
      NProgress.done();
    };
  }, [pathname, searchParams]);

  return (
    <style jsx global>{`
      #nprogress {
        pointer-events: none;
      }
      #nprogress .bar {
        background: ${color};
        position: fixed;
        z-index: 99999;
        top: 0;
        left: 0;
        width: 100%;
        height: ${height}px;
      }
      #nprogress .peg {
        display: block;
        position: absolute;
        right: 0px;
        width: 100px;
        height: 100%;
        box-shadow: 0 0 10px ${color}, 0 0 5px ${color};
        opacity: 1;
        transform: rotate(3deg) translate(0px, -4px);
      }
    `}</style>
  );
}
