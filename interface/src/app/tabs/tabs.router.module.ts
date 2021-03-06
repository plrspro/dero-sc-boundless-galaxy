import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { TabsPage } from './tabs.page';

const routes: Routes = [
  {
    path: 'app',
    component: TabsPage,
    children: [
      {
        path: 'overview',
        children: [
          {
            path: '',
            loadChildren: '../tab1/tab1.module#Tab1PageModule'
          }
        ]
      },
      {
        path: 'tabposessions',
        children: [
          {
            path: '',
            loadChildren: '../tabposessions/tabposessions.module#TabposessionsPageModule'
          }
        ]
      },
      {
        path: 'galaxy',
        children: [
          {
            path: '',
            loadChildren: '../tab2/tab2.module#Tab2PageModule'
          },
          {
            path: 'view/:x/:y',
            loadChildren: '../view/view.module#ViewPageModule'
          },
        ]
      },
      {
        path: 'settings',
        children: [
          {
            path: '',
            loadChildren: '../tab3/tab3.module#Tab3PageModule'
          }
        ]
      },
      {
        path: 'faq',
        children: [
          {
            path: '',
            loadChildren: '../faq/faq.module#FaqPageModule'
          }
        ]
      },
      {
        path: 'txs',
        children: [
          {
            path: '',
            loadChildren: '../txs/txs.module#TxsPageModule'
          }
        ]
      },
      {
        path: '',
        redirectTo: '/app/overview',
        pathMatch: 'full'
      }
    ]
  },
  {
    path: '',
    redirectTo: '/app/overview',
    pathMatch: 'full'
  }
];

@NgModule({
  imports: [
    RouterModule.forChild(routes)
  ],
  exports: [RouterModule]
})
export class TabsPageRoutingModule {}
