import { Metadata } from 'next';
import React from 'react';

interface FullPageLayoutProps {
    children: React.ReactNode;
}

export const metadata: Metadata = {
    title: 'Sigchos E-commerce',
    description: 'Sigchos E-commerce — productos locales y turismo rural del cantón Sigchos, Cotopaxi.'
};

export default function FullPageLayout({ children }: FullPageLayoutProps) {
    return <React.Fragment>{children}</React.Fragment>;
}
