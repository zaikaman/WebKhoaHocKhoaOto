import React from 'react';

interface LabelProps {
  children: React.ReactNode;
  htmlFor: string;
}

export const Label = ({ children, htmlFor }: LabelProps) => {
  return (
    <label htmlFor={htmlFor} className="text-sm font-medium">
      {children}
    </label>
  );
}; 